module FileSplitter

import lang::java::jdt::m3::Core;
import lang::java::m3::Core;
import lang::java::m3::AST;
import IO;
import String;
import List;

map[int, list[loc]] findDuplications(loc project, int duplicationType){
	<LOC, LOCbyFile, ASTbyFile> = getDuplication(project, duplicationType);
	map[int, list[loc]] acc = ();
	for(i <- ASTbyFile)
		<_, acc> = getHash(ASTbyFile[i], acc);
	return acc;
}

tuple[int, map[loc, int], map[loc, Declaration]] getDuplication(loc projectLocation, int dupType){
	M3 model = createM3FromEclipseProject(projectLocation);
	<LOC, fileloc> = getLoc(model);
	map[loc, Declaration] asts = getAsts(model, dupType);
	iprintln(asts);
	return <LOC, fileloc, asts>;
}

private map[loc, Declaration] getAsts(M3 model, 2){
	map[loc, Declaration] asts = ();
	for(loc l <- [cl | <cl, _> <- model@containment, cl.scheme == "java+compilationUnit"])
		asts += (l : createAstFromFile(l, false));
	return asts;
}
private default map[loc, Declaration] getAsts(M3 model, _){
	map[loc, Declaration] asts = ();
	for(loc l <- [cl | <cl, _> <- model@containment, cl.scheme == "java+compilationUnit"])
		asts += (l : createAstFromFile(l, true));
	return asts;
}

tuple[int, map[int, list[loc]]] getHash(Declaration decl, map[int, list[loc]] acc){
	int hash = 0;
	visit(decl){
		case \compilationUnit(_, tree): <hash, acc> = hashDeclarationList(tree, acc);
		case \compilationUnit(_, _, tree): <hash, acc> = hashDeclarationList(tree, acc);
		case \enum(name, types, tree1, tree2): <hash, acc> = hashClass(name, types, tree1 + tree2, decl, acc);
		case \enumConstant(name, tree): <hash, acc> = hashEnumConstant(name, tree, acc);
		case \enumConstant(name, tree1, tree2):{
			<hash, acc> = hashEnumConstant(name, tree1, acc);
			<hash2, acc> = getHash(tree2, acc);
			hash += hash2; // TODO: ""
		}
		case \class(name, tree1, tree2, tree3): <hash, acc> = hashClass(name, tree1 + tree2, tree3, decl, acc);
		case \class(tree):{
			<hash, acc> = hashDecarationList(tree, acc);
			hash += hashString("<i@typ>"); // TODO: ""
		}
		case \interface(name, tree1, tree2, tree3): <hash, acc> = hashClass(name, tree1 + tree2, tree3, decl, acc);
		case \field(t, tree): <hash, acc> = hashVariable(t, tree, decl, acc);
		case \initializer(s):{
			<hash, acc> = getHashStatement(s, acc);
			hash += "<decl@typ>"; //TODO: ""
		}
		case \method(ret, name, tree1, tree2):{
			<hash, acc> = hashMethod(name, tree1, tree2, decl, acc);
			<hash2, acc> = getHashType(t, acc); //TODO: ""
			hash += hash2;
		}
		case \method(ret, name, tree1, tree2, s):{
			<hash, acc> = hashSMethod(s, name, tree1, tree2, decl, acc);
			<hash2, acc> = getHashType(ret, acc); //TODO: ""
			hash += hash2;
		}
		case \constructor(name, tree1, tree2, s): <hash, acc> = hashSMethod(s, name, tree1, tree2, decl, acc);
		case \variables(t, tree): <hash, acc> = hashVariable(t, tree, decl, acc);
		case \typeParameter(name, types):{
			hash = hashString(name);
			for(i <- types){
				<hash2, acc> = getHashType(i, acc); // TODO: ""
				hash += hash2;
			}
		}
		case \annotationType(name, tree):{
			<hash, acc> = hashDeclarationList(tree, acc);
			hash += hashString(name + "<decl@typ>");
		}
		case \annotationTypeMember(t, name):{
			<hash, acc> = getHashType(t, acc);
			hash += hashString(name + "<decl@typ>"); // TODO
		}
		case \annotationTypeMember(t, name, expr):{
			<hash, acc> = getHashExpression(expr, acc);
			<hash2, acc> = getHashType(t, acc);
			hash += hashString(name + "<decl@typ>") + hash2; // TODO
		}
		case \parameter(t, name, val):{
			<hash, acc> = getHashType(t, acc);
			hash += val + hashString(name); // TODO
		}
		case \vararg(t, name):{
			<hash, acc> = getHashType(t, acc);
			hash += hashString(name + "<decl@typ>"); // TODO
		}
		//default: return <0, acc>;
	}
	list[loc] l;
	try
		l = acc[hash];
	catch: l = [];
	try
		return <hash, acc + (hash : l + decl@src)>;
	catch: return <hash, acc>;
}

tuple[int, map[int, list[loc]]] getHashExpression(Expression expr, map[int, list[loc]] acc){
	int hash = 0;
	visit(expr){
		case \arrarAccess(expr1, expr2): <hash, acc> = hashTwoExpr(expr1, expr2, acc);
		case \newArray(t, tree, expr1):{
			<hash, acc> = hashTypeAndTree(t, tree, acc);
			<hash2, acc> = getHashExpression(expr1, acc);
			hash += hash2; // TODO
		}
		case \newArray(t, tree): <hash, acc> = hashTypeAndTree(t, tree, acc);
		case \arrayInitializier(tree): <hash, acc> = hashExprList(tree);
		case \assignment(expr1, op, expr2): hashAssignment(expr1, op, expr2, acc);
		case \cast(t, expr1):{
			<hash, acc> = getHashExpression(expr1, acc);
			<hash2, acc> = getHashType(t, acc); // TODO
			hash += hash2;
		}
		case \newObject(expr1, t, tree, decl):{
			<hash, acc> = getHash(decl, acc);
			<hash2, acc> = getHashExpression(expr1, acc);
			<hash3, acc> = hashTypeAndTree(t, tree, acc);
			hash += hash2 + hash3; // TODO
		}
		case \newObject(expr1, t, tree): <hash, acc> = hashNewObject(expr1, t, tree, acc);
		case \newObject(t, tree, decl): <hash, acc> = hashNewObject(decl, t, tree, acc);
		case \newObject(t, tree): <hash, acc> = hashTypeAndTree(t, tree, acc);
		case \qualifiedName(expr1, expr2): <hash, acc> = hashTwoExpr(expr1, expr2, acc);
		case \conditional(expr1, expr2, expr3):{
			<hash, acc> = hashTwoExpr(expr1, expr2, acc);
			<hash2, acc> = getHashExpression(expr3, acc);
			hash += hash2; // TODO
		}
		case \fieldAccess(b, expr1, name):{
			<hash, acc> = getHashExpression(expr1, acc);
			hash += hashString(name + "<b>"); // TODO
		}
		case \fieldAccess(b, name): hash = hashString(name + "<b>");
		case \instanceof(expr1, t):{
			<hash, acc> = getHashExpression(expr1, acc);
			<hash2, acc> = getHashType(t, acc); // TODO
			hash += hash2;
		}
		case \methodCall(b, name, tree):{
			<hash, acc> = hashMethodCall(b, name, tree, acc);
			hash += hashString("<expr@typ>"); // TODO
		}
		case \methodCall(b, expr1, name, tree):{
			<hash, acc> = hashMethodCall(b, name, tree, acc);
			<hash2, acc> = getHashExpression(expr1, acc);
			hash += hash2; // TODO
		}
		case \null(): hash = hashString("null()");
		case \booleanLiteral(b): hash = hashString("<b>()");
		case \type(t): <hash, acc> = getHashType(t, acc);
		case \variable(name, v): hash = v + hashString(name); // TODO
		case \variable(name, v, expr1):{
			<hash, acc> = getHashExpression(expr1, acc);
			hash += v + hashString(name); // TODO
		}
		case \bracket(expr1): <hash, acc> = getHashExpression(expr1, acc);
		case \this(): hash = hashString("this()");
		case \this(expr1):{
			<hash, acc> = getHashExpression(expr1, acc);
			hash += hashString("this()"); // TODO
		}
		case \super(): hash = hashString("super()");
		case \declarationExpression(Declaration decl): <hash, acc> = getHash(decl, acc);
		case \infix(expr1, op, expr2): <hash, acc> = hashAssignment(expr1, op, expr2, acc);
		case \postfix(expr1, op): <hash, acc> = hashExprStr(expr1, op, acc);
		case \prefix(op, expr1): <hash, acc> = hashExprStr(expr1, op, acc);
		case \normalAnnotation(name, tree):{
			<hash, acc> = hashExprList(tree, acc);
			hash += hashString(name);
		}
		case \_(name, expr1): <hash, acc> = hashExprStr(expr1, name, acc);
		case \_(val): hash = hashString(val + "<expr@typ>");
		//default: return <0, acc>;
	}
	list[loc] l;
	try
		l = acc[hash];
	catch: l = [];
	try
		return <hash, acc + (hash : l + expr@src)>;
	catch: return <hash, acc>;
}

tuple[int, map[int, list[loc]]] getHashStatement(Statement s, map[int, list[loc]] acc){
	int hash = 0;
	visit(s){
		case \assert(expr):{
			<hash, acc> = getHashExpression(expr, acc);
			hash += hashString("assert()");
		}
		case \assert(expr1, expr2):{
			<hash, acc> = hashTwoExpr(expr1, expr2, acc);
			hash += hashString("assert()");
		}
		case \block(tree):{
			<hash, acc> = hashStatementList(tree, acc);
			hash += hashString("block()");
		}
		case \break(): hash = hashString("break()");
		case \break(label): hash = hashString(label + "break()");
		case \continue(): hash = hashString("continue()");
		case \conitnue(label): hash = hashString(label + "continue()");
		case \do(s1, expr): <hash, acc> = hashExprS(expr, s1, acc);
		case \empty(): hash = hashString("empty()");
		case \foreach(decl, expr, s1):{
			<hash, acc> = getHash(decl, acc);
			<hash2, acc> = hashExprS(expr, s1, acc);
			hash += hash2;
		}
		case \for(tree1, expr, tree2, s1):{
			<hash, acc> = hashFor(tree1 + tree2, s1, acc);
			<hash2, acc> = getHashExpression(expr, acc);
			hash += hash2;
		}
		case \for(tree1, tree2, s1): <hash, acc> = hashFor(tree1 + tree2, s1);
		case \if(expr, s1): <hash, acc> = hashExprS(expr, s1, acc);
		case \if(expr, s1, s2):{
			<hash, acc> = hashExprS(expr, s1, acc);
			<hash2, acc> = getHashStatement(s2, acc);
			hash += hash2;
		}
		case \label(name, s1):{
			<hash, acc> = getHashStatement(s1, acc);
			hash += hashString(name);
		}
		case \return(): hash = hashString("return()");
		case \return(expr):{
			<hash, acc> = getHashExpression(expr, acc);
			hash += hashString("return()");
		}
		case \switch(expr, tree):{
			<hash, acc> = hashStatementList(tree, acc);
			<hash2, acc> = getHashExpression(expr, acc);
			hash += hash2;
		}
		case \case(expr):{
			<hash, acc> = getHashExpression(expr, acc);
			hash += hashString("case()");
		}
		case \defaultCase(): hash = hashString("defaultcase");
		case \synchronizedStatement(expr, s1): <hash, acc> = hashExprS(expr, s1);
		case \throw(expr):{
			<hash, acc> = getHashExpression(expr, acc);
			hash += hashString("throw");
		}
		case \try(s1, tree): <hash, acc> = hashStatementS(s1, tree, acc);
		case \try(s1, tree, s2):{
			<hash, acc> = hashStatementS(s1, tree, acc);
			<hash2, acc> = getHashStatement(s2, acc);
			hash += hash2;
		}
		case \catch(decl, s1):{
			<hash, acc> = getHash(decl, acc);
			<hash2, acc> = getHashStatement(s1, acc);
			hash += hash2;
		}
		case \declarationStatement(decl): <hash, acc> = getHash(decl, acc);
		case \while(expr, s1): <hash, acc> = hashExprS(expr, s1, acc);
		case \expressionStatement(expr): <hash, acc> = getHashExpression(expr, acc);
		case \constructorCall(b, expr, tree):{
			<hash, acc> = hashConstructor(b, tree, acc);
			<hash2, acc> = getHashExpression(expr, acc);
			hash += hash2;
		}
		case \constructorCall(b, tree): <hash, acc> = hashConstructor(b, tree, acc);
		//default: return <0, acc>;
	}
	list[loc] l;
	try
		l = acc[hash];
	catch: l = [];
	try
		return <hash, acc + (hash : l + s@src)>;
	catch: return <hash, acc>;
}

tuple[int, map[int, list[loc]]] getHashType(Type t, map[int, list[loc]] acc){
	int hash = 0;
	visit(t){
		case arrayType(t2): <hash, acc> = hashTypeAndString(t2, "[]", acc);
		case parameterizedType(t2): <hash, acc> = hashTypeAndString(t2, "parameterized", acc);
		case qualifiedType(t2, expr):{
			<hash, acc> = getHashExpression(expr, acc);
			<hash2, acc> = getHashType(t2, acc);
			hash += hash2;
		}
		case simpleType(expr):{
			<hash, acc> = getHashExpression(expr, acc);
			hash += hashString("simple");
		}
		case unionType(tree):{
			hash = hashString("union");
			for(i <- tree){
				<hash2, acc> = getHashType(i, acc);
				hash += hash2;
			}
		}
		case wildcard(): hash = hashString("wildcard");
		case upperbound(t2): <hash, acc> = hashTypeAndString(t2, "upperbound", acc);
		case lowerbound(t2): <hash, acc> = hashTypeAndString(t2, "lowerbound", acc);
		//default: hash = hashString("<t>");
	}
	return <hash, acc>;
}

tuple[int, map[int, list[loc]]] hashDeclarationList(list[Declaration] tree, map[int, list[loc]] acc){
	list[tuple[int, loc]] hashes = [];
	for(i <- tree){
		<hash, acc> = getHash(i, acc);
		hashes += <hash, i@src>;
	}
	return hashSubLists(hashes, acc);
}

tuple[int, map[int, list[loc]]] hashExprList(list[Expression] tree, map[int, list[loc]] acc){
	list[tuple[int, loc]] hashes = [];
	for(i <- tree){
		<hash, acc> = getHashExpression(i, acc);
		hashes += <hash, i@src>;
	}
	return hashSubLists(hashes, acc);
}

tuple[int, map[int, list[loc]]] hashStatementList(list[Statement] tree, map[int, list[loc]] acc){
	list[tuple[int, loc]] hashes = [];
	for(i <- tree){
		<hash, acc> = getHashStatement(i, acc);
		hashes += <hash, i@src>;
	}
	return hashSubLists(hashes, acc);
}

tuple[int, map[int, list[loc]]] hashTypeAndString(Type t, str s, map[int, list[loc]] acc){
	<hash, acc> = getHashType(t, acc);
	return <hash + hashString(s), acc>;
}

tuple[int, map[int, list[loc]]] hashConstructor(bool b, list[Expression] tree, map[int, list[loc]] acc){
	<hash, acc> = hashExprList(tree, acc);
	return <hash + hashString("<b>()"), acc>;
}

tuple[int, map[int, list[loc]]] hashStatementS(Statement s, list[Statement] tree, map[int, list[loc]] acc){
	<hash, acc> = getHashStatement(s, acc);
	<hash2, acc> = hashStatementList(tree, acc);
	return <hash + hash2, acc>;
}

tuple[int, map[int, list[loc]]] hashExprS(Expression expr, Statement s, map[int, list[loc]] acc){
	<hash, acc> = getHashStatement(s, acc);
	<hash2, acc> = getHashExpression(expr, acc);
	return <hash + hash2, acc>;
}

tuple[int, map[int, list[loc]]] hashFor(list[Expression] tree, Statement s, map[int, list[loc]] acc){
	<hash, acc> = hashExprList(tree, acc);
	<hash2, acc> = getHashStatement(s, acc);
	return <hash + hash2, acc>; // TODO
}

tuple[int, map[int, list[loc]]] hashTwoExpr(Expression expr1, Expression expr2, map[int, list[loc]] acc){
	<hash, acc> = getHashExpression(expr1, acc);
	<hash2, acc> = getHashExpression(expr2, acc);
	return <hash + hash2, acc>; // TODO
}

tuple[int, map[int, list[loc]]] hashExprStr(Expression expr, str op, map[int, list[loc]] acc){
	<hash, acc> = getHashExpression(expr, acc);
	return <hash + hashString(op), acc>; // TODO
}

tuple[int, map[int, list[loc]]] hashAssignment(Expression expr1, str op, Expression expr2, map[int, list[loc]] acc){
	<hash, acc> = hashTwoExpr(expr1, expr2, acc);
	return <hash + hashString(op), acc>; // TODO
}

tuple[int, map[int, list[loc]]] hashMethodCall(bool b, str name, list[Expression] tree, map[int, list[loc]] acc){
	<hash, acc> = hashConstructor(b, tree, acc);
	return <hash + hashString(name), acc>; // TODO
}

tuple[int, map[int, list[loc]]] hashNewObject(value exprdecl, Type t, list[Expression] tree, map[int, list[loc]] acc){
	visit(exprdecl){
		case Declaration: <hash, acc> = getHash(exprdecl, acc);
		case Expression: <hash, acc> = getHashExpression(exprdecl, acc);
	}
	<hash2, acc> = hashTypeAndTree(t, tree, acc);
	return <hash + hash2, acc>; // TODO
}

tuple[int, map[int, list[loc]]] hashTypeAndTree(Type t, list[Expression] tree, map[int, list[loc]] acc){
	<hash, acc> = hashExprList(tree, acc);
	<hash2, acc> = getHashType(t, acc);
	return <hash + hash2, acc>; // TODO
}

tuple[int, map[int, list[loc]]] hashVariable(Type t, list[Expression] tree, Declaration self, map[int, list[loc]] acc){
	<hash, acc> = hashExprList(tree, acc);
	<hash2, acc> = getHashType(t, acc); //TODO: ""
	return <hash + hash2, acc>; // TODO
}

tuple[int, map[int, list[loc]]] hashClass(str name, list[Type] types, list[Declaration] tree, Declaration self, map[int, list[loc]] acc){
	<hash, acc> = hashDeclTypes(types, tree, acc);
	return <hash + hashString(name), acc>; // TODO: ""
}

tuple[int, map[int, list[loc]]] hashDeclTypes(list[Type] types, list[Declaration] tree, map[int, list[loc]] acc){
	<hash, acc> = hashDeclarationList(tree, acc);
	for(i <- types){
		<hash2, acc> = getHashType(i, acc); // TODO: ""
		hash += hash2;
	}
	return <hash, acc>;
}

tuple[int, map[int, list[loc]]] hashEnumConstant(str name, list[Expression] tree, map[int, list[loc]] acc){
	<hash, acc> = hashExprList(tree, acc);
	return <hash + hashString(name), acc>; // TODO
}

tuple[int, map[int, list[loc]]] hashSMethod(Statement s, str name, list[Declaration] tree1, list[Expression] tree2, Declaration self, map[int, list[loc]] acc){
	<hash, acc> = hashMethod(name, tree1, tree2, self, acc);
	<hash2, acc> = getHashStatement(s, acc);
	return <hash + hash2, acc>; // TODO
}

tuple[int, map[int, list[loc]]] hashMethod(str name, list[Declaration] tree, list[Expression] tree2, Declaration self, map[int, list[loc]] acc){
	<hash, acc> = hashDeclarationList(tree, acc);
	<hash2, acc> = hashExprList(tree2, acc);
	return <hash + hash2 + hashString(name), acc>; // TODO
}

// This function hashes all sublists (so not subsequences!) and returns the final hash of the list.
tuple[int, map[int, list[loc]]] hashSubLists([], map[int, list[loc]] acc) = <hashString("[]"), acc>;
tuple[int, map[int, list[loc]]] hashSubLists(list[tuple[int, loc]] l, map[int, list[loc]] acc){
	<<hash, hashl>, rest> = pop(l);
	int i = 0;
	for(i < size(rest)){
		<<x, hashl2>, rest> = pop(rest);
		hash += x; // TODO: operator
		hashl.end = hashl2.end;
		list[loc] l2;
		try
			l2 = acc[hash];
		catch: l2 = [];
		acc += (hash : l2 + hashl);
		<_, acc> = hashSubLists(rest, acc);
		i += 1;
	}
	return <hash, acc>;
}

int hashString(str string){
	int hash = 7;
	int i = 0;
	for(i < size(string)){
		hash = hash * 31 + charAt(string, i);
		i += 1;
	}
	return hash;
}

// Get the Source Lines of Code of a project.
tuple[int, map[loc, int]] getLoc(M3 model){
	int linesOfCode= 0;
	map[loc, int] fileloc = ();
	for(loc l <- [cl | <cl,_> <- model@containment, cl.scheme == "java+compilationUnit"]){
		int lines = getLinesOfUnit(readFile(l), l, model);
		fileloc += (l : lines);
		linesOfCode += lines;
	}
	return <linesOfCode, fileloc>;
}

// Gets the Lines of code of a compilation unit.
int getLinesOfUnit(str file, loc cu, M3 model){
	int linesOfCode = 0;
	// Get all comments for the compilation unit and remove them.
	for(c <- [c2 | <_,c2> <- model@documentation, c2.path == cu.path]){
		// If the comment is multiline, insert extra newline, otherwise the next code
		// snippet will be interpreted as 1 LOC:
		//   foo(); /*
		//   */ bar();
		if(c.end.line - c.begin.line == 0)
			file = replaceAll(file, readFile(c), "");
		else
			file = replaceAll(file, readFile(c), "\n");
	}
	// Count the lines that contain not only whitespace.
	for(/[^\s].*\r?(\n|\Z)/ := file)
		linesOfCode += 1;
	return linesOfCode;
}
