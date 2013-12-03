Definitions.

D  = [0-9]
A  = [_A-Za-z]


Rules.

{D}+ :
    {token,{integer,TokenLine,list_to_integer(TokenChars)}}.

{D}+\.{D}+((E|e)(\+|\-)?{D}+)? :
                {token,{float,TokenLine,list_to_float(TokenChars)}}.
{A}+ :
                {token,{symbol,TokenLine,list_to_atom(TokenChars)}}.
[\*+-/\(\)] :
                {token,{TokenChars,TokenLine}}.

[\000-\s]+  : skip_token.

Erlang code.

