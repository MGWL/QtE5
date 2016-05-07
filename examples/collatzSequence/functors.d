module functors;

import std.algorithm;
import std.range;
import std.traits;

auto foreverApply(alias Functional, Argument)(Argument x)
{
	alias FunctorType = ReturnType!Functional;
	
	struct ForeverFunctorRange
	{
		FunctorType argument;
		
		this(Argument)(Argument argument)
		{
			this.argument = cast(FunctorType) argument;
		}
		
		enum empty = false;
		
		FunctorType front()
		{
			return argument;
		}
		
		void popFront()
		{
			argument = Functional(argument);
		}
	}
	
	return ForeverFunctorRange(x);
}


auto doTimes(alias Functional, Argument, Number)(Argument x, Number n)
{
	assert(n >= 0, "Argument must be not negative !");
	
	auto N = cast(size_t) n;
	
	return foreverApply!Functional(x).take(N);
}