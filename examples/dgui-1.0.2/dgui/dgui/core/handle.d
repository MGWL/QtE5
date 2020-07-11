/** DGui project file.

Copyright: Trogu Antonio Davide 2011-2013

License: $(HTTP boost.org/LICENSE_1_0.txt, Boost License 1.0).

Authors: Trogu Antonio Davide
*/
module dgui.core.handle;

abstract class Handle(T)
{
	protected T _handle;

	@property public final bool created() const
	{
		return cast(bool)this._handle;
	}

	@property  public /*final*/ T handle()
	{
		return this._handle;
	}
}
