import pdfplumber
import csv
import zipfile

def extrair_tabela_do_pdf(caminho_pdf):
    with pdfplumber.open(caminho_pdf) as pdf:
        todos_os_dados = []
        cabecalho = None
        for pagina in pdf.pages:
            tabela = pagina.extract_table()
            if tabela:
                if cabecalho is None:
                    cabecalho = tabela[0]
                    todos_os_dados.append(cabecalho)
                    todos_os_dados.extend(tabela[1:])
                else:
                    todos_os_dados.extend(tabela[1:])
        return todos_os_dados

def substituir_abreviacoes(linha):
    for i, celula in enumerate(linha):
        if celula == "OD":
            linha[i] = "Odontologia"
        elif celula == "AMB":
            linha[i] = "Ambulatorial"
    return linha

with zipfile.ZipFile("../TESTE DE WEB SCRAPING/downloads/Anexos.zip", 'r') as zipf:
    zipf.extract("Anexo_I.pdf", "dados") 
    
caminho_pdf = "dados/Anexo_I.pdf"
dados = extrair_tabela_do_pdf(caminho_pdf)

dados = [dados[0]] + [substituir_abreviacoes(linha) for linha in dados[1:]]

caminho_csv = "dados/rol_procedimentos.csv" 
with open(caminho_csv, 'w', newline='', encoding='utf-8') as f:
    escritor = csv.writer(f)
    escritor.writerows(dados)

print(f"Dados extraídos e salvos em {caminho_csv}")

nome_arquivo_zip = "dados/Teste_Rafael_Cabral.zip"
with zipfile.ZipFile(nome_arquivo_zip, 'w', zipfile.ZIP_DEFLATED) as zipf:
    zipf.write(caminho_csv, arcname="rol_procedimentos.csv")

print(f"Arquivo compactado em {nome_arquivo_zip}")