using concurrent

@NoDoc
internal const class LocalStash {
	
	private const Str prefix
	
	new make(Str prefix) {
		this.prefix = prefix
	}
	
	@Operator
	Obj? get(Str name, |->Obj|? valFunc := null) {
		val := Actor.locals[key(name)]
		if (val == null) {
			if (valFunc != null) {
				val = valFunc.call
				set(name, val)
			}
		}
		return val
	}

	@Operator
	Void set(Str name, Obj? value) {
		Actor.locals[key(name)] = value
	}
	
	private Str key(Str name) {
		return "${prefix}.${name}"
	}
}