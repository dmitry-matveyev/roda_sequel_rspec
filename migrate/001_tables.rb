Sequel.migration do
  change do
    create_table(:records) do
      primary_key :id
    end
  end
end
