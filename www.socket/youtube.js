const sql = require('./sql.js')

class YouTube {
	constructor() {
		sql.run(`
			CREATE TABLE IF NOT EXISTS yt_related  (
				id INTEGER PRIMARY KEY NOT NULL,

				related TEXT NOT NULL UNIQUE DEFAULT '',

				result TEXT NOT NULL DEFAULT '',
				used INTEGER NOT NULL DEFAULT 1,
				date INTEGER NOT NULL
			);
		`)

		sql.run(`
			CREATE TABLE IF NOT EXISTS yt_search  (
				id INTEGER PRIMARY KEY NOT NULL,

				search TEXT NOT NULL UNIQUE DEFAULT '',

				result TEXT NOT NULL DEFAULT '',
				used INTEGER NOT NULL DEFAULT 1,
				date INTEGER NOT NULL
			);
		`)

		// EXPLAIN QUERY PLAN SELECT id,d,m,u,p FROM wall WHERE to_username = ''

		sql.run('CREATE INDEX IF NOT EXISTS related ON yt_related (related)')
		sql.run('CREATE INDEX IF NOT EXISTS search ON yt_search (search)')

		this.insert_related = sql.insert(
			'INSERT INTO yt_related (related, result, date) VALUES (:related, :result,  :date)',
		)
		this.insert_search = sql.insert(
			'INSERT INTO yt_search (search, result, date) VALUES (:search, :result,  :date)',
		)

		this.select_related = sql.select(
			'SELECT id, related, result, used, date FROM yt_related WHERE related = :related LIMIT 1',
		)

		this.select_search = sql.select(
			'SELECT id, search , result, used, date FROM yt_search  WHERE search  = :search  LIMIT 1',
		)

		this.update_related = sql.delete(
			'UPDATE yt_related set used = used+1, date = :date WHERE related = :related',
		)

		this.update_search = sql.delete(
			'UPDATE yt_search set used = used+1, date = :date WHERE search = :search',
		)
	}
}

const youtube = new YouTube()
module.exports = youtube
