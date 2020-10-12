import { observable, configure, action } from 'mobx'
import { render, cleanup, Component as _Component } from 'mobx-jsx'

configure({
	// https://mobx.js.org/refguide/api.html
	enforceActions: 'always',
	computedRequiresReaction: true,
	reactionScheduler: requestAnimationFrame,
})

class Component extends _Component {
	no = {
		constructor: null,
		state: null,
		bind: null,
	}
	constructor(props) {
		super(props)
		if (this.componentDidMount) {
			Promise.resolve().then(() => this.componentDidMount())
		}
		if (this.componentWillUnmount) {
			cleanup(() => this.componentWillUnmount())
		}
		this.bind(this)
		if (this._constructor) this._constructor(props)
	}

	bind(o) {
		for (var m of Object.getOwnPropertyNames(Object.getPrototypeOf(o))) {
			if (o[m] && o[m].bind) {
				if (this.no[m] === undefined) {
					o[m] = action(o[m].bind(o))
				}
			}
		}
	}
}
