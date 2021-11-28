# passport is a hash of fields, ex. {'ecl' => 'grey',
# 'pid' => '123', ...}

def all_fields?(passport)
  all_fields = passport.keys.length == 8
  missing_cid = passport.keys.length == 7 && !passport.key?('cid')
  all_fields || missing_cid
end

def count_valid(passports)
  passports.count { |p| all_fields?(p) }
end

def all_fields_strict?(p)
  return false unless all_fields?(p)
  return false unless p['byr'].to_i.between?(1920, 2002)
  return false unless p['iyr'].to_i.between?(2010, 2020)
  return false unless p['eyr'].to_i.between?(2020, 2030)

  hgt_regex_match = /^([0-9]+)(cm|in)$/.match(p['hgt'])
  return false unless hgt_regex_match

  number = hgt_regex_match[1].to_i
  units = hgt_regex_match[2]
  return false if units == 'cm' && !number.between?(150, 193)
  return false if units == 'in' && !number.between?(59, 76)

  return false unless /^#[0-9a-f]{6}$/ =~ p['hcl']
  return false unless /^(amb|blu|brn|gry|grn|hzl|oth)$/ =~ p['ecl']
  return false unless /^[0-9]{9}$/ =~ p['pid']

  true
end

def count_valid_strict(passports)
  passports.count { |p| all_fields_strict?(p) }
end

data = ''
open('input.txt') do |f|
  # read the whole file into a string so we can split
  # it by the empty lines ("\n\n")
  data = f.read
end

# input:
# ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
# byr:1937 iyr:2017 cid:147 hgt:183cm
#
# iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
# hcl:#cfa07d byr:1929
# ...
passports = data.split("\n\n").map do |multiline_passport|
  single_line_passport = multiline_passport.gsub("\n", ' ')
  fields = single_line_passport.split(' ')
  # kv_pairs is a 2-D list where each element is a list of size 2
  # containing the key and value for that field
  # .to_h will convert the 2-D list to a hash
  # Ex. [['ecl, 'grey'], ['pid', '123']] ->
  # {'ecl' => 'grey', 'pid' => '123'}
  kv_pairs = fields.map { |field| field.split(':') }
  kv_pairs.to_h
end
puts count_valid(passports)
puts count_valid_strict(passports)
