class TitleBracketsValidator < ActiveModel::Validator
  def validate(record)
      
    stack = []
    symbols = { '{' => '}', '[' => ']', '(' => ')' }
    record.title.each_char do |c|
        stack << c if symbols.key?(c)
        record.errors[:title] << "can't have mixed brackets" if symbols.key(c) && symbols.key(c) != stack.pop
    end
    if stack.empty? == false
        record.errors[:title] << "can't have unclosed brackets" 
    end
    record.errors[:title] << "can't have empty brackets" if not (record.title =~ /\(\s*\)|\[\s*\]|\{\s*\}/).nil?
  end
end