ActiveRecord::Schema.define(:version => 0) do
  create_table :projects, :force => true do |t|
    t.column :name, :string
    t.column :start_date, :date
    t.column :end_date, :date
    t.column :priority, :integer
    t.timestamps
  end
end
