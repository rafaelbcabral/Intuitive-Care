import chardet

# Verificação do Encoding do arquivo "Relatorio_cadop.csv"
with open("dados/Relatorio_cadop.csv", "rb") as f:
    result = chardet.detect(f.read())
    print(result)