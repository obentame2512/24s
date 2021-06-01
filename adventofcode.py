import pandas
# read the input
df = pandas.read_excel(r'C:\Users\obentame\Documents\exp.xlsx', names = ['exp'], skiprows = [0], nrows = 200)

# find the two entries that sum to 2020 and then multiply those two numbers together
def sum_expense_2020(l):
    i = 0
    j = 1
    stop = 0
    while i < len(l)-1 and stop == 0:
        while j < len(l) and l[i]+l[j] != 2020:
            j = j+1
        if j == len(l):
            i = i+1
            j = i+1
        else:
            stop = 1
            
    return l[i]*l[j]
    
    
    # find the three entries that sum to 2020 and then multiply those three numbers together
    def sum_expense_3_2020(l):
    i = 0
    j = 1
    k = 2
    stop = 0
    while i < len(l)-2 and stop == 0:
        while j < len(l)-1 and stop == 0:
            while k < len(l) and l[i]+l[j]+l[k] != 2020:
                k = k+1
            if k == len(l):
                j = j+1
                k = j+1
            else:
                stop=1
        if j == len(l)-1:
                i = i+1
                j = i+1
                k = j+1
            
    return l[i]*l[j]*l[k]

li = df['exp'].tolist()
print(sum_expense_2020(li))
print(sum_expense_3_2020(li))
