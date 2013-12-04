-module(eval).
-compile([export_all]).

-record(env,{bindings = [],operands = [],operations = []}).

% true if token goes to operands stack
isop({integer,_}) -> true;
isop({float,_})   -> true;
isop({symbol,_})  -> true;
isop(_)           -> false.


% operations and their priorities
operations() -> [
	{"+",0,plus/2,2      },
	{"-",0,minus/2,2     },
	{"*",1,multiply/2,2  },
	{"/",1,devide/2,2    },
	{"(",10,nop/0,0      },
	{")",10,nop/0,0      },
	{eof,-100,noneed/0,0 }
].

priority(X)      -> {_,P,_} = lists:keyfind(X,1,operations()), P.



%apply operation in current environment 

apply(O,B,R) ->
	{_,_,Proc,Pnum} = lists:keyfind(O,1,operations()),
	if
		len(R) < Pnum: -> throw()
			body
	end
	{P,NB}          = lists:split(Pnum,R),



%check if list head  is equal to given
equal_head(C,[])    -> false;
equal_head(C,[C|_]) -> true;
equal_head(C,[_|_]) -> false.


% reduces stacks based on operator precedence
reduce(B,R,[],eof)   -> {B,R,[]};
reduce(B,R,[],NP)    -> {B,R,[NP]};
reduce(B,R,[O|T],NP) -> P1 = priority(NP),
						P2 = priority(O),
						if
							P1 > P2                    -> {B,R,[NP,O|T]};
							(P1 == P2) and (P1 == ")") -> {B,R,T};
							true                       -> {NB,NR,NT} = reduce(B,[apply(O,B,R)|R],T,NP)
								
						end.





evaluate(#env{bindings = _, operands = [R|_], operations = []},Toks) -> throw("Syntax error");
evaluate(#env{bindings = _, operands = [R], operations = []},Toks)   -> R;

evaluate(#env{bindings = B, operands = R, operations = O},[T|TL])    ->
	case T of
		{error,ErrorInfo} -> throw("Unrecognized token");
		{token,TokenInfo} -> case isop(TokenInfo) of
								false  -> evaluate(#env{bindings = B, operands = [TokenInfo|R], operations = O},TL);
								_      -> evaluate(#env{bindings = B, operands = R, operations = [TokenInfo|O]},TL)
							 end
	end.


eval(S) ->
	{ok,Toks} = lexer:string(S),
	env = #env{},
	evaluate(env,Toks).



safe_eval(S) ->
	R = (catch eval(S)),
	case R of
		{'EXIT',Reason } -> io:format("exception ~w~n",[Reason]) , 0;
		R                -> R	
	end.






