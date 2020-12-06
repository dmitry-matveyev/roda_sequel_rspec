RSpec.describe '/api' do
  describe '/records' do
    let!(:record) { Record.create }

    subject { get('/api/records') }

    it { expect(subject.status).to eq(200) }
    xit { expect(JSON.parse(subject.body)).to eq(Record.all.map(&:values)) }
  end
end
