import requests
from bs4 import BeautifulSoup
import zipfile

def download_file(url):
    try:
        response = requests.get(url)
        response.raise_for_status()  
        return response.content 
    except requests.exceptions.RequestException as e:
        print(f"Erro ao baixar o arquivo: {e}")
        return None

url = 'https://www.gov.br/ans/pt-br/acesso-a-informacao/participacao-da-sociedade/atualizacao-do-rol-de-procedimentos'
try:
    response = requests.get(url)
    response.raise_for_status() 

    soup = BeautifulSoup(response.content, 'html.parser')

    anexo1_pdf = soup.find('a', href=lambda href: href and ('Anexo_I' in href and href.endswith('.pdf')))
    anexo2_pdf = soup.find('a', href=lambda href: href and ('Anexo_II' in href and href.endswith('.pdf')))

    if anexo1_pdf and anexo2_pdf:
        anexo1_url = anexo1_pdf['href']
        anexo2_url = anexo2_pdf['href']

        anexo1_content = download_file(anexo1_url)
        anexo2_content = download_file(anexo2_url)

        print("Anexos I e II baixados com sucesso.")
        
        try:
            with zipfile.ZipFile('downloads/Anexos.zip', 'w', zipfile.ZIP_DEFLATED) as zipf:
                zipf.writestr('Anexo_I.pdf', anexo1_content)  
                zipf.writestr('Anexo_II.pdf', anexo2_content)
                print("Anexos I e II compactados com êxito no arquivo Anexos.zip, dentro da pasta downloads.")
        except Exception as e:
            print(f"Erro ao compactar os arquivos: {e}")

    else:
        print("Anexos I ou II não encontrados.")
except requests.exceptions.RequestException as e:
    print(f"Erro ao acessar o site: {e}")
except Exception as e:
    print(f"Erro inesperado: {e}")
