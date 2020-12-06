# TODO: fix me

class App
  hash_routes '/api' do
    get 'records' do
      Record.all
    end
  end
end
