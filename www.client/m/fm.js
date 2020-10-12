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

/*class Counter1 extends Component {
	@observable counter = 0
	componentWillUnmount() {
		clearInterval(this.timer)
	}
	render() {
		this.timer = setInterval(
			action(() => {
				this.counter++
			}),
			1000,
		)

		return <span>{this.counter}</span>
	}
}
class Counter2 extends Component {
	@observable counter = 0
	componentDidMount() {}
	componentWillUnmount() {}
	render() {
		this.timer = setInterval(
			action(() => {
				this.counter++
			}),
			5000,
		)

		return <span>{this.counter}</span>
	}
}

class App extends Component {
	@observable hide = false
	constructor(props) {
		super(props)
		setTimeout(this.toggle, 5000)
	}
	toggle() {
		this.hide = true
	}
	render() {
		return (
			<div>
				<div>
					Counter1: <Counter1 />
				</div>
				{this.hide ? null : (
					<div class="counter2">
						Counter2: <Counter2 />
					</div>
				)}
			</div>
		)
	}
}

setTimeout(function() {
	render(() => <App />, document.querySelector('.app'))
}, 1000)
*/
