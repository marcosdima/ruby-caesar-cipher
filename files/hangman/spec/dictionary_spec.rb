require_relative '../lib/hangman'

FILE_PATH = './files/google-10000-english-no-swears.txt'

describe "Testing dictionary" do
  let(:first_word) { File.foreach(FILE_PATH).first.chomp }

  it "Dictionary initialize should load words from the file" do
    dic = Hangman::Dictionary.new(FILE_PATH)
    expect(dic.words).not_to be_empty
  end

  it "Dictionary should load words in a hash with the word length as key" do
    dic = Hangman::Dictionary.new(FILE_PATH)
    expect(dic.words).to have_key(first_word.length)
    expect(dic.words[first_word.length]).to include(first_word)
  end
end