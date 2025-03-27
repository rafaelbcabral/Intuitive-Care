import chardet

# Verificação do Encoding do arquivo "Relatorio_cadop.csv"
with open("dados/1T2023.csv", "rb") as f:
    result = chardet.detect(f.read(10000))
    print(result)
    
with open("dados/2T2023.csv", "rb") as f:
    result2 = chardet.detect(f.read(10000))
    print(result2)    
    
with open("dados/3T2023.csv", "rb") as f:
    result3 = chardet.detect(f.read(10000))
    print(result3)
    
with open("dados/4T2023.csv", "rb") as f:
    result4 = chardet.detect(f.read(10000))
    print(result4)
    
with open("dados/1T2024.csv", "rb") as f:
    result5 = chardet.detect(f.read(10000))
    print(result5)
    
with open("dados/2T2024.csv", "rb") as f:
    result6 = chardet.detect(f.read(10000))
    print(result6)
    
with open("dados/3T2024.csv", "rb") as f:
    result7 = chardet.detect(f.read(10000))
    print(result7)
    
with open("dados/4T2024.csv", "rb") as f:
    result8 = chardet.detect(f.read(10000))
    print(result8)