class CreateTables

  def self.if_not_exists(connection)
    connection.exec("
      CREATE TABLE IF NOT EXISTS peeps(
      id SERIAL PRIMARY KEY,
      username VARCHAR(30) NOT NULL,
      peep VARCHAR(50) NOT NULL,
      created_at TIMESTAMP default current_timestamp
      )
    ")
  end

end
