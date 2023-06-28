/*

Regular Expression Syntax
A regular expression describes a set of strings. The simplest regular expression is one that has no special characters in it. 
For example, the regular expression hello matches hello and nothing else.

Nontrivial regular expressions use certain special constructs so that they can match more than one string. 
For example, the regular expression hello|world contains the | alternation operator and matches either the hello or world.

As a more complex example, the regular expression B[an]*s matches any of the strings Bananas, Baaaaas, Bs, and any other string starting with a B, 
ending with an s, and containing any number of a or n characters in between.

The following list covers some of the basic special characters and constructs that can be used in regular expressions. 
For information about the full regular expression syntax supported by the ICU library used to implement regular expression support, visit the International Components for Unicode web site.

^

Match the beginning of a string.

mysql> SELECT REGEXP_LIKE('fo\nfo', '^fo$');                   -> 0
mysql> SELECT REGEXP_LIKE('fofo', '^fo');                      -> 1
$

Match the end of a string.

mysql> SELECT REGEXP_LIKE('fo\no', '^fo\no$');                 -> 1
mysql> SELECT REGEXP_LIKE('fo\no', '^fo$');                    -> 0
.

Match any character (including carriage return and newline, although to match these in the middle of a string, 
the m (multiple line) match-control character or the (?m) within-pattern modifier must be given).

mysql> SELECT REGEXP_LIKE('fofo', '^f.*$');                    -> 1
mysql> SELECT REGEXP_LIKE('fo\r\nfo', '^f.*$');                -> 0
mysql> SELECT REGEXP_LIKE('fo\r\nfo', '^f.*$', 'm');           -> 1
mysql> SELECT REGEXP_LIKE('fo\r\nfo', '(?m)^f.*$');           -> 1
a*

Match any sequence of zero or more a characters.

mysql> SELECT REGEXP_LIKE('Ban', '^Ba*n');                     -> 1
mysql> SELECT REGEXP_LIKE('Baaan', '^Ba*n');                   -> 1
mysql> SELECT REGEXP_LIKE('Bn', '^Ba*n');                      -> 1
a+

Match any sequence of one or more a characters.

mysql> SELECT REGEXP_LIKE('Ban', '^Ba+n');                     -> 1
mysql> SELECT REGEXP_LIKE('Bn', '^Ba+n');                      -> 0
a?

Match either zero or one a character.

mysql> SELECT REGEXP_LIKE('Bn', '^Ba?n');                      -> 1
mysql> SELECT REGEXP_LIKE('Ban', '^Ba?n');                     -> 1
mysql> SELECT REGEXP_LIKE('Baan', '^Ba?n');                    -> 0
de|abc

Alternation; match either of the sequences de or abc.

mysql> SELECT REGEXP_LIKE('pi', 'pi|apa');                     -> 1
mysql> SELECT REGEXP_LIKE('axe', 'pi|apa');                    -> 0
mysql> SELECT REGEXP_LIKE('apa', 'pi|apa');                    -> 1
mysql> SELECT REGEXP_LIKE('apa', '^(pi|apa)$');                -> 1
mysql> SELECT REGEXP_LIKE('pi', '^(pi|apa)$');                 -> 1
mysql> SELECT REGEXP_LIKE('pix', '^(pi|apa)$');                -> 0
(abc)*

Match zero or more instances of the sequence abc.

mysql> SELECT REGEXP_LIKE('pi', '^(pi)*$');                    -> 1
mysql> SELECT REGEXP_LIKE('pip', '^(pi)*$');                   -> 0
mysql> SELECT REGEXP_LIKE('pipi', '^(pi)*$');                  -> 1
{1}, {2,3}

Repetition; {n} and {m,n} notation provide a more general way of writing regular expressions 
that match many occurrences of the previous atom (or “piece”) of the pattern. m and n are integers.

a*

Can be written as a{0,}.

a+

Can be written as a{1,}.

a?

Can be written as a{0,1}.

To be more precise, a{n} matches exactly n instances of a. a{n,} matches n or more instances of a. 
a{m,n} matches m through n instances of a, inclusive. If both m and n are given, m must be less than or equal to n.

mysql> SELECT REGEXP_LIKE('abcde', 'a[bcd]{2}e');              -> 0
mysql> SELECT REGEXP_LIKE('abcde', 'a[bcd]{3}e');              -> 1
mysql> SELECT REGEXP_LIKE('abcde', 'a[bcd]{1,10}e');           -> 1
[a-dX], [^a-dX]

Matches any character that is (or is not, if ^ is used) either a, b, c, d or X. A - character between two other characters 
forms a range that matches all characters from the first character to the second. For example, [0-9] matches any decimal digit. 
To include a literal ] character, it must immediately follow the opening bracket [. 
To include a literal - character, it must be written first or last. Any character that does not have a defined special meaning inside a [] pair matches only itself.

mysql> SELECT REGEXP_LIKE('aXbc', '[a-dXYZ]');                 -> 1
mysql> SELECT REGEXP_LIKE('aXbc', '^[a-dXYZ]$');               -> 0
mysql> SELECT REGEXP_LIKE('aXbc', '^[a-dXYZ]+$');              -> 1
mysql> SELECT REGEXP_LIKE('aXbc', '^[^a-dXYZ]+$');             -> 0
mysql> SELECT REGEXP_LIKE('gheis', '^[^a-dXYZ]+$');            -> 1
mysql> SELECT REGEXP_LIKE('gheisa', '^[^a-dXYZ]+$');           -> 0
[=character_class=]

Within a bracket expression (written using [ and ]), [=character_class=] represents an equivalence class. 
It matches all characters with the same collation value, including itself. For example, if o and (+) are the members of an equivalence class, 
[[=o=]], [[=(+)=]], and [o(+)] are all synonymous. An equivalence class may not be used as an endpoint of a range.

[:character_class:]

Within a bracket expression (written using [ and ]), [:character_class:] represents a character class that matches all characters belonging to that class. 
The following table lists the standard class names. These names stand for the character classes defined in the ctype(3) manual page. 
A particular locale may provide other class names. A character class may not be used as an endpoint of a range.

Character Class Name	Meaning
alnum	Alphanumeric characters
alpha	Alphabetic characters
blank	Whitespace characters
cntrl	Control characters
digit	Digit characters
graph	Graphic characters
lower	Lowercase alphabetic characters
print	Graphic or space characters
punct	Punctuation characters
space	Space, tab, newline, and carriage return
upper	Uppercase alphabetic characters
xdigit	Hexadecimal digit characters
mysql> SELECT REGEXP_LIKE('justalnums', '[[:alnum:]]+');       -> 1
mysql> SELECT REGEXP_LIKE('!!', '[[:alnum:]]+');               -> 0
To use a literal instance of a special character in a regular expression, precede it by two backslash (\) characters. 
The MySQL parser interprets one of the backslashes, and the regular expression library interprets the other. For example, 
to match the string 1+2 that contains the special + character, only the last of the following regular expressions is the correct one:

mysql> SELECT REGEXP_LIKE('1+2', '1+2');                       -> 0
mysql> SELECT REGEXP_LIKE('1+2', '1\+2');                      -> 0
mysql> SELECT REGEXP_LIKE('1+2', '1\\+2');                     -> 1
Regular Expression Resource Control
REGEXP_LIKE() and similar functions use resources that can be controlled by setting system variables:

The match engine uses memory for its internal stack. To control the maximum available 
memory for the stack in bytes, set the regexp_stack_limit system variable.

The match engine operates in steps. To control the maximum number of steps performed by the engine (and thus indirectly the execution time), 
set the regexp_time_limit system variable. Because this limit is expressed as number of steps, it affects execution time only indirectly. 
Typically, it is on the order of milliseconds.

Regular Expression Compatibility Considerations
Prior to MySQL 8.0.4, MySQL used the Henry Spencer regular expression library to support regular expression operations, 
rather than International Components for Unicode (ICU). The following discussion describes differences between the Spencer and ICU libraries that may affect applications:

With the Spencer library, the REGEXP and RLIKE operators work in byte-wise fashion, 
so they are not multibyte safe and may produce unexpected results with multibyte character sets. 
In addition, these operators compare characters by their byte values and 
accented characters may not compare as equal even if a given collation treats them as equal.

ICU has full Unicode support and is multibyte safe. Its regular expression functions treat all strings as UTF-16. 
You should keep in mind that positional indexes are based on 16-bit chunks and not on code points. This means that, 
when passed to such functions, characters using more than one chunk may produce unanticipated results, such as those shown here:

mysql> SELECT REGEXP_INSTR('🍣🍣b', 'b');
+--------------------------+
| REGEXP_INSTR('??b', 'b') |
+--------------------------+
|                        5 |
+--------------------------+
1 row in set (0.00 sec)

mysql> SELECT REGEXP_INSTR('🍣🍣bxxx', 'b', 4);
+--------------------------------+
| REGEXP_INSTR('??bxxx', 'b', 4) |
+--------------------------------+
|                              5 |
+--------------------------------+
1 row in set (0.00 sec)
Characters within the Unicode Basic Multilingual Plane, which includes characters used by most modern languages, are safe in this regard:

mysql> SELECT REGEXP_INSTR('бжb', 'b');
+----------------------------+
| REGEXP_INSTR('бжb', 'b')   |
+----------------------------+
|                          3 |
+----------------------------+
1 row in set (0.00 sec)

mysql> SELECT REGEXP_INSTR('עבb', 'b');
+----------------------------+
| REGEXP_INSTR('עבb', 'b')   |
+----------------------------+
|                          3 |
+----------------------------+
1 row in set (0.00 sec)

mysql> SELECT REGEXP_INSTR('µå周çб', '周');
+------------------------------------+
| REGEXP_INSTR('µå周çб', '周')       |
+------------------------------------+
|                                  3 |
+------------------------------------+
1 row in set (0.00 sec)
Emoji, such as the “sushi” character 🍣 (U+1F363) used in the first two examples, are not included in the Basic Multilingual Plane, 
but rather in Unicode's Supplementary Multilingual Plane. Another issue can arise with emoji and other 4-byte characters when REGEXP_SUBSTR() 
or a similar function begins searching in the middle of a character. Each of the two statements 
in the following example starts from the second 2-byte position in the first argument. 
The first statement works on a string consisting solely of 2-byte (BMP) characters. 
The second statement contains 4-byte characters which are incorrectly interpreted in the result because 
the first two bytes are stripped off and so the remainder of the character data is misaligned.

mysql> SELECT REGEXP_SUBSTR('周周周周', '.*', 2);
+----------------------------------------+
| REGEXP_SUBSTR('周周周周', '.*', 2)     |
+----------------------------------------+
| 周周周                                 |
+----------------------------------------+
1 row in set (0.00 sec)

mysql> SELECT REGEXP_SUBSTR('🍣🍣🍣🍣', '.*', 2);
+--------------------------------+
| REGEXP_SUBSTR('????', '.*', 2) |
+--------------------------------+
| ?㳟揘㳟揘㳟揘                  |
+--------------------------------+
1 row in set (0.00 sec)
For the . operator, the Spencer library matches line-terminator characters (carriage return, newline) 
anywhere in string expressions, including in the middle. To match line terminator characters in the middle of strings with ICU, specify the m match-control character.

The Spencer library supports word-beginning and word-end boundary markers ([[:<:]] and [[:>:]] notation). 
ICU does not. For ICU, you can use \b to match word boundaries; double the backslash because MySQL interprets it as the escape character within strings.

The Spencer library supports collating element bracket expressions ([.characters.] notation). ICU does not.

For repetition counts ({n} and {m,n} notation), the Spencer library has a maximum of 255. ICU has no such limit, 
although the maximum number of match engine steps can be limited by setting the regexp_time_limit system variable.

ICU interprets parentheses as metacharacters. To specify a literal open or close parenthesis ( in a regular expression, it must be escaped:

mysql> SELECT REGEXP_LIKE('(', '(');
ERROR 3692 (HY000): Mismatched parenthesis in regular expression.
mysql> SELECT REGEXP_LIKE('(', '\\(');
+-------------------------+
| REGEXP_LIKE('(', '\\(') |
+-------------------------+
|                       1 |
+-------------------------+
mysql> SELECT REGEXP_LIKE(')', ')');
ERROR 3692 (HY000): Mismatched parenthesis in regular expression.
mysql> SELECT REGEXP_LIKE(')', '\\)');
+-------------------------+
| REGEXP_LIKE(')', '\\)') |
+-------------------------+
|                       1 |
+-------------------------+
ICU also interprets square brackets as metacharacters, but only the opening square bracket need be escaped to be used as a literal character:


mysql> SELECT REGEXP_LIKE('[', '[');
ERROR 3696 (HY000): The regular expression contains an
unclosed bracket expression.
mysql> SELECT REGEXP_LIKE('[', '\\[');
+-------------------------+
| REGEXP_LIKE('[', '\\[') |
+-------------------------+
|                       1 |
+-------------------------+
mysql> SELECT REGEXP_LIKE(']', ']');
+-----------------------+
| REGEXP_LIKE(']', ']') |
+-----------------------+
|                     1 |
+-----------------------+


*/