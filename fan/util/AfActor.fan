using concurrent

@NoDoc
internal const class AfActor : Actor {
	private const static Log log := Log.get("AfActor")

	const LocalStash stash
	
	new make(ActorPool pool, Str stashName) : super(pool) { 
		prefix := AfActor#.pod.name
		stash = LocalStash("${prefix}.$stashName")
	}

	Obj? get(|Obj?->Obj?| f) {
		return (send(f).get as Unsafe).val
	}

	override Obj? receive(Obj? msg) {
		func := (msg as |Obj?->Obj?|)
		try {
			return Unsafe(func.call(this))
		} catch (Err e) {
			// if the func has a return type, then an the Err is rethrown on assignment
			// else we log the Err so the Thread doesn't fail silently
			if (func.returns == Void#)
				log.err("AfActor receive()", e)
			throw e
		}
	}
}
