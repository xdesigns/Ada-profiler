import java_cup.runtime.Symbol;
import java.lang.String;
import java.lang.System;

class  KEY_TAB
        {
       		String kw;
        	int kwv;

		KEY_TAB(String kw,int kwv){
			this.kw=kw;
			this.kwv=kwv;
		}
        };
%%
DIGIT = [0-9]
EXTENDED_DIGIT = [0-9a-zA-Z]
INTEGER = ({DIGIT}(_?{DIGIT})*)
EXPONENT = ([eE](\+?|-){INTEGER})
DECIMAL_LITERAL = {INTEGER}(\.?{INTEGER})?{EXPONENT}?
BASE = {INTEGER}
BASED_INTEGER = {EXTENDED_DIGIT}(_?{EXTENDED_DIGIT})*
BASED_LITERAL = {BASE}#{BASED_INTEGER}(\.{BASED_INTEGER})?#{EXPONENT}?

%cup
%char
%line

%init{
	key_tab=new KEY_TAB[NUM_KEYWORDS];
	key_tab[0] = new KEY_TAB("ABORT",	 sym.ABORT);
	key_tab[1] = new KEY_TAB("ABS",	 sym.ABS);
	key_tab[2] =  new KEY_TAB("ABSTRACT",	 sym.ABSTRACT);
	key_tab[3] =   new KEY_TAB("ACCEPT",	 sym.ACCEPT);
	key_tab[4] =   new KEY_TAB("ACCESS",	 sym.ACCESS);
	key_tab[5] =   new KEY_TAB("ALIASED",	 sym.ALIASED);
	key_tab[6] =   new KEY_TAB("ALL",	 sym.ALL);
	key_tab[7] =   new KEY_TAB("AND",	 sym.AND);
	key_tab[8] =   new KEY_TAB("ARRAY",	 sym.ARRAY);
	key_tab[9] =   new KEY_TAB("AT",	 sym.AT);
	key_tab[10] =   new KEY_TAB("BEGIN",	 sym.BEGIN);
	key_tab[11] =   new KEY_TAB("BODY",	 sym.BODY);
	key_tab[12] =   new KEY_TAB("CASE",	 sym.CASE);
	key_tab[13] =   new KEY_TAB("CONSTANT",	 sym.CONSTANT);
	key_tab[14] =   new KEY_TAB("DECLARE",	 sym.DECLARE);
	key_tab[15] =   new KEY_TAB("DELAY",	 sym.DELAY);
	key_tab[16] =   new KEY_TAB("DELTA",	 sym.DELTA);
	key_tab[17] =   new KEY_TAB("DIGITS",	 sym.DIGITS);
	key_tab[18] =   new KEY_TAB("DO",	 sym.DO);
	key_tab[19] =   new KEY_TAB("ELSE",	 sym.ELSE);
	key_tab[20] =   new KEY_TAB("ELSIF",	 sym.ELSIF);
	key_tab[21] =   new KEY_TAB("END",	 sym.END);
	key_tab[22] =   new KEY_TAB("ENTRY",	 sym.ENTRY);
	key_tab[23] =   new KEY_TAB("EXCEPTION",	 sym.EXCEPTION);
	key_tab[24] =   new KEY_TAB("EXIT",	 sym.EXIT);
	key_tab[25] =   new KEY_TAB("FOR",	 sym.FOR);
	key_tab[26] =   new KEY_TAB("FUNCTION",	 sym.FUNCTION);
	key_tab[27] =   new KEY_TAB("GENERIC",	 sym.GENERIC);
	key_tab[28] =   new KEY_TAB("GOTO",	 sym.GOTO);
	key_tab[29] =   new KEY_TAB("IF",	 sym.IF);
	key_tab[30] =   new KEY_TAB("IN",	 sym.IN);
	key_tab[31] =   new KEY_TAB("IS",	 sym.IS);
	key_tab[32] =   new KEY_TAB("LIMITED",	 sym.LIMITED);
	key_tab[33] =   new KEY_TAB("LOOP",	 sym.LOOP);
	key_tab[34] =   new KEY_TAB("MOD",	 sym.MOD);
	key_tab[35] =   new KEY_TAB("NEW",	 sym.NEW);
	key_tab[36] =   new KEY_TAB("NOT",	 sym.NOT);
	key_tab[37] =   new KEY_TAB("NULL",	 sym.NuLL);
	key_tab[38] =   new KEY_TAB("OF",	 sym.OF);
	key_tab[39] =   new KEY_TAB("OR",	 sym.OR);
	key_tab[40] =   new KEY_TAB("OTHERS",	 sym.OTHERS);
	key_tab[41] =   new KEY_TAB("OUT",	 sym.OUT);
	key_tab[42] =   new KEY_TAB("PACKAGE",	 sym.PACKAGE);
	key_tab[43] =   new KEY_TAB("PRAGMA",	 sym.PRAGMA);
	key_tab[44] =   new KEY_TAB("PRIVATE",	 sym.PRIVATE);
	key_tab[45] =   new KEY_TAB("PROCEDURE",	 sym.PROCEDURE);
	key_tab[46] =   new KEY_TAB("PROTECTED",	 sym.PROTECTED);
	key_tab[47] =   new KEY_TAB("RAISE",	 sym.RAISE);
	key_tab[48] =   new KEY_TAB("RANGE",	 sym.RANGE);
	key_tab[49] =   new KEY_TAB("RECORD",	 sym.RECORD);
	key_tab[50] =   new KEY_TAB("REM",	 sym.REM);
	key_tab[51] =   new KEY_TAB("RENAMES",	 sym.RENAMES);
	key_tab[52] =   new KEY_TAB("REQUEUE",	 sym.REQUEUE);
	key_tab[53] =   new KEY_TAB("RETURN",	 sym.RETURN);
	key_tab[54] =   new KEY_TAB("REVERSE",	 sym.REVERSE);
	key_tab[55] =   new KEY_TAB("SELECT",	 sym.SELECT);
	key_tab[56] =   new KEY_TAB("SEPARATE",	 sym.SEPARATE);
	key_tab[57] =   new KEY_TAB("SUBTYPE",	 sym.SUBTYPE);
	key_tab[58] =   new KEY_TAB("TAGGED",	 sym.TAGGED);
	key_tab[59] =   new KEY_TAB("TASK",	 sym.TASK);
	key_tab[60] =   new KEY_TAB("TERMINATE",	 sym.TERMINATE);
	key_tab[61] =   new KEY_TAB("THEN",	 sym.THEN);
	key_tab[62] =   new KEY_TAB("TYPE",	 sym.TYPE);
	key_tab[63] =   new KEY_TAB("UNTIL",	 sym.UNTIL);
	key_tab[64] =   new KEY_TAB("USE",	 sym.USE);
	key_tab[65] =   new KEY_TAB("WHEN",	 sym.WHEN);
	key_tab[66] =   new KEY_TAB("WHILE",	 sym.WHILE);
	key_tab[67] =   new KEY_TAB("WITH",	 sym.WITH);
	key_tab[68] =   new KEY_TAB("XOR",	 sym.XOR);
%init}

%eofval{
  return new Symbol (sym.EOF,Integer.toString(yychar)+"+"+Integer.toString(yyline));
%eofval}


%{
	final static int NUM_KEYWORDS = 69;
	KEY_TAB[] key_tab;

	Symbol lk_keyword(String str)
		 
	 {
		int min;
		int max;
		int guess, compare;

		min = 0;
		max = NUM_KEYWORDS-1;
		guess = (min + max) / 2;
		str=str.toUpperCase();
		for (guess=(min+max)/2; min<=max; guess=(min+max)/2) 
		{
			if((compare=str.compareTo(key_tab[guess].kw))<0)
			{
				max=guess-1;
			}
			else if(compare>0)
			{
				min=guess+1;
			}
			else 
			{
				return new Symbol(key_tab[guess].kwv,Integer.toString(yychar)+"+"+Integer.toString(yyline));
			}
		}
		return new Symbol(sym.identifier,Integer.toString(yychar)+"+"+Integer.toString(yyline));
	}
%}

%%

"."                     {return new Symbol(sym.DOT,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
"<"                     {return new Symbol(sym.LT,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
"("                     {return new Symbol(sym.LPAR,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
"+"                     {return new Symbol(sym.PLUS,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
"|"                     {return new Symbol(sym.BAR,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
"&"                     {return new Symbol(sym.BITAND,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
"*"                     {return new Symbol(sym.AST,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
")"                     {return new Symbol(sym.RPAR,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
";"                     {return new Symbol(sym.SEMI,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
"-"                     {return new Symbol(sym.MINUS,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
"/"                     {return new Symbol(sym.FSLASH,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
","                     {return new Symbol(sym.COMMA,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
">"                     {return new Symbol(sym.GT,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
":"                     {return new Symbol(sym.COLON,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
"="                     {return new Symbol(sym.EQUAL,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
"'"                     {return new Symbol(sym.TIC,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
".."                    {return new Symbol(sym.DOT_DOT,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
"<<"                    {return new Symbol(sym.LT_LT,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
"<>"                    {return new Symbol(sym.BOX,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
"<="                    {return new Symbol(sym.LT_EQ,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
"**"                    {return new Symbol(sym.EXPON,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
"/="                    {return new Symbol(sym.NE,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
">>"                    {return new Symbol(sym.GT_GT,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
">="                    {return new Symbol(sym.GE,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
":="                    {return new Symbol(sym.IS_ASSIGNED,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
"=>"                    {return new Symbol(sym.RIGHT_SHAFT,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
[a-zA-Z](_?[a-zA-Z0-9])* {return(lk_keyword(yytext()));}
"'"."'"                 {return new Symbol(sym.char_lit,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
\"(\"\"|[^\n\"])*\"   {return new Symbol(sym.char_string,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
{DECIMAL_LITERAL}       {return new Symbol(sym.numeric_lit,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
{BASED_LITERAL}         {return new Symbol(sym.numeric_lit,Integer.toString(yychar)+"+"+Integer.toString(yyline));}
--.*\n                  {;}
[ \t\n\f\r]               {;}
.                      {System.out.println("Illegal character:"+yytext()+": on line"+yyline+"\n");
                        }
