firstBy = (function () {
	function n(n) {
		return n
	}

	function t(n) {
		return 'string' == typeof n ? n.toLowerCase() : n
	}

	function r(r, e) {
		if (
			((e =
				'number' == typeof e
					? {
							direction: e,
					  }
					: e || {}),
			'function' != typeof r)
		) {
			var i = r
			r = function (n) {
				return n[i] ? n[i] : ''
			}
		}
		if (1 === r.length) {
			var u = r,
				o = e.ignoreCase ? t : n
			r = function (n, t) {
				return o(u(n)) < o(u(t)) ? -1 : o(u(n)) > o(u(t)) ? 1 : 0
			}
		}
		return -1 === e.direction
			? function (n, t) {
					return -r(n, t)
			  }
			: r
	}

	function e(n, t) {
		var i = 'function' == typeof this ? this : !1,
			u = r(n, t),
			o = i
				? function (n, t) {
						return i(n, t) || u(n, t)
				  }
				: u
		return (o.thenBy = e), o
	}
	return e
})()
