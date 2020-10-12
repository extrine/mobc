class DB {
	constructor() {
		this.run = this.run.bind(this)
		this.select = this.select.bind(this)

		this.insert = this.insert.bind(this)
		this.update = this.insert
		this.delete = this.insert

		// windows
		if (__dirname.indexOf(':') !== -1) {
			this.db = new require('better-sqlite3')(__dirname + '/../data/db.sqlite', { timeout: 100 })
			// osx
		}else if ( __dirname.indexOf('/Users/') != -1) {
			this.db = new require('/usr/local/lib/node_modules/better-sqlite3/')(__dirname + '/../data/db.sqlite', { timeout: 100 })
			// linux
		} else {
			this.db = new require('/usr/local/lib/node_modules/better-sqlite3/')(
				__dirname + '/../../data/db.sqlite',
				{ timeout: 100 },
			)
		}

		this.db.pragma('secure_delete = false')
		this.db.pragma('auto_vacuum = 2') //incremental
		this.db.pragma('journal_mode = WAL')
		this.db.pragma('automatic_index=on')
	}

	run(q) {
		try {
			return this.db.exec(q)
		} catch (e) {
			console.error(e)
		}
	}
	insert(q) {
		try {
			q = this.db.prepare(q)
		} catch (e) {
			console.error(e)
		}

		return function(o) {
			try {
				return q.run(o).lastInsertRowid
			} catch (e) {
				console.error(e)
			}
		}
	}
	select(q) {
		try {
			q = this.db.prepare(q)
		} catch (e) {
			console.error(e)
		}
		return q.all.bind(q)
	}
}

const db = new DB()
module.exports = db
