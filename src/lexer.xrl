Definitions.

D  = [0-9]
A  = [_A-Za-z]


Rules.

{D}+ :
    {token,{integer,list_to_integer(TokenChars)}}.

{D}+\.{D}+((E|e)(\+|\-)?{D}+)? :
                {token,{float,list_to_float(TokenChars)}}.
{A}+ :
                {token,{symbol,list_to_atom(TokenChars)}}.
[\*+-/\(\)] :
                {token,{TokenChars}}.
[\n]        : skip_token.
[\000-\s]+  : skip_token.

Erlang code.

