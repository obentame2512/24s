import pandas
df = pandas.read_excel(r'C:\Users\obentame\Documents\passwords.xlsx', header = None, nrows = 1000)
li = df[0].tolist()
def valid_pass(l):
    res = 0
    for i in l:
        # temporary variable
        tmp = i.split('-')
        # lowest number of times the letter must appear for the password to be valid
        low_occ = int(tmp[0])
        tmp = tmp[1].split(' ',1)
        # maximum number of times the letter must appear for the password to be valid
        max_occ = int(tmp[0])
        tmp = tmp[1].split(': ')
        # number of occurences of the given letter 
        occ = tmp[1].count(tmp[0])
        if occ >= low_occ and occ <= max_occ:
            res = res + 1
    return res
        
print(valid_pass(li))

def valid_pass_position(l):
    res = 0
    for i in l:
        # temporary variable
        tmp = i.split('-')
        # one position in the password
        position_1 = int(tmp[0]) - 1
        tmp = tmp[1].split(' ',1)
        # second position in the password
        position_2 = int(tmp[0]) - 1
        tmp = tmp[1].split(': ')
        # the given letter 
        letter = tmp[0]
        password = tmp[1]
        # if exactly one the two positions contains the given letter then the password is valid
        if (password[position_1] == letter and password[position_2] != letter) or (password[position_2] == letter and password[position_1] != letter) :
            res = res + 1
    return res
  
print(valid_pass_position(li))
