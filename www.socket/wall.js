const sql = require('./sql.js')

class Wall {
	constructor() {
		sql.run(`
			CREATE TABLE IF NOT EXISTS wall  (
				id INTEGER PRIMARY KEY NOT NULL,

				d INTEGER NOT NULL,
				m TEXT NOT NULL DEFAULT '',
				to_username TEXT NOT NULL DEFAULT '',
				u TEXT NOT NULL DEFAULT '',
				p INTEGER NOT NULL DEFAULT 1
			);
		`)

		// EXPLAIN QUERY PLAN SELECT id,d,m,u,p FROM wall WHERE to_username = ''

		sql.run('CREATE INDEX IF NOT EXISTS to_username ON wall (to_username)')
		sql.run('CREATE INDEX IF NOT EXISTS u ON wall (u)')
		sql.run('CREATE INDEX IF NOT EXISTS u_to_username ON wall (u,to_username)')

		this.insert = sql.insert(
			'INSERT INTO wall (d, m, u, to_username, p) VALUES (:d, :m, :u, :to_username, :p)',
		)

		this.select = sql.select(
			'SELECT id,d,m,u,p FROM wall WHERE to_username = :to_username ORDER BY id DESC LIMIT 200',
		)

		this.delete_by_id = sql.delete('DELETE FROM wall WHERE id = :id')

		this.delete_by_username_all = sql.delete(
			'DELETE FROM wall WHERE to_username = :username or u = :username',
		)
		this.delete_by_username_all_except_mobc = sql.delete(
			"DELETE FROM wall WHERE (to_username = :username or u = :username) AND  to_username != 'omgmobc.com' AND u != 'omgmobc.com'",
		)
		this.delete_to_username_by_username = sql.delete(
			"DELETE FROM wall WHERE to_username = :to_username AND u = :by_username AND u != 'omgmobc.com' ",
		)
		this.delete_older_mobc = sql.delete(
			"DELETE FROM wall WHERE (to_username = 'omgmobc.com' or u = 'omgmobc.com') AND CAST(d AS INTEGER) < CAST(:date AS INTEGER)",
		)
		this.rename_user_to = sql.delete(
			'UPDATE wall set to_username = :rename_to WHERE to_username = :rename_from',
		)
		this.rename_user_from = sql.delete('UPDATE wall set u = :rename_to WHERE u = :rename_from')
	}
}

const wall = new Wall()
module.exports = wall
