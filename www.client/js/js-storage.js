var Storage = function () {
	this.p = 'mobc.'
	var v = '0'
	try {
		this.sL = window.localStorage
		this.sL.setItem('t', 't')
		this.sL.removeItem('t', 't')
	} catch (e) {
		try {
			this.sL = window.sessionStorage
			this.sL.setItem('t', 't')
			this.sL.removeItem('t', 't')
		} catch (e) {
			this.sL = {
				v: {},
				getItem: function () {
					return this.v
				},
				setItem: function (v) {
					this.v = v
				},
				clear: function () {
					this.v = {}
				},
			}
		}
	}
	var o = this.get()
	if (o.v != v) {
		this.sL.clear()
		this.set({
			v: v,
		})
	}
}

Storage.prototype.set = function (v) {
	this.sL.setItem(this.p, JSON.stringify(v))
}
Storage.prototype.get = function () {
	var v = this.sL.getItem(this.p)
	if (v) {
		try {
			return JSON.parse(v)
		} catch (e) {
			return {}
		}
	} else {
		return {}
	}
}
Storage.prototype.i = function () {
	var v = this.sL.getItem('i')
	if (!v) {
		v = sha1(
			'abc' +
				Date.now() +
				'-' +
				new Date().getTime() +
				'-' +
				gd() +
				'-' +
				gd() +
				'-' +
				gd() +
				'-' +
				gd() +
				'-' +
				Math.random() +
				'-' +
				Math.random() +
				'-' +
				Math.random() +
				'-' +
				Math.random(),
		)
		this.sL.setItem('i', v)
	}
	return v
}

function gd() {
	return Math.random().toString(36).replace('.', '').substr(1, 7)
}
Storage.prototype.update = function (v) {
	var o = this.get()
	Object.keys(v).forEach(function (i) {
		o[i] = v[i]
	})
	this.set(o)
}
