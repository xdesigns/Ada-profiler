###############################################
#### ADA PROGRAMMING LANGUAGE PROFILER ########
#### AUTHOR: NIJITH JACOB              ########
#### EMAIL: nijith89@gmail.com         ########
###############################################

1. Files
   * scan.flex : JFlex Specification for generating Ada tokens
   * parse.cup : CUP parse file
2. Requirements
   * The program require Ada compiler - gnat to be present in the system.
3. How to Run?
   * Use JFlex (JFlex.jar) to generate Yylex.java from scan.flex
   * Execute java -jar java-cup-11a.jar parse.cup. This will generate sym.java and parser.java
   * Execute javac parser.java sym.java Yylex.java
   * Finally to run, execute java parser
4. Example 
   * Click "Choose File" and select sample/dseq.adb
   * As arguments give sample/rseq.inp 1 2
   * If eveything succeded, click View SUmmary to view the summary report
5. GUI Options
   * Save History: This will retain all the instrumented code in the folder <file>_history
   * Clean Up: remove all files generated as the result of compilation

