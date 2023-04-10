require './lib/db/connect.rb'

class Peep
  def self.query(query, db_connection = Connect.initiate(:chitter))
    db_connection.exec(query)
  end

  def self.add(params)
    query("INSERT INTO peeps 
     (username, peep)  
     VALUES ('#{params[:username]}','#{params[:peep]}')  
     RETURNING id").to_a
  end

  def self.all(order_by = 'DESC', limit = 100)
    users_return = query("SELECT * FROM peeps ORDER BY created_at #{order_by} LIMIT #{limit.to_s}").to_a
    users_return.map{ |pair| pair.transform_keys(&:to_sym) }
  end
end
