# 📋 Busca de Operadoras de Saúde

Um sistema completo para busca de operadoras de saúde com backend em Python/Flask e frontend em Vue.js.

## 📦 Dependências BACK-END
```bash
pip install flask pandas fuzzywuzzy flask-cors numpy
```
## Ou com requirements.txt:
```bash
echo "flask==2.3.2
pandas==2.0.3
fuzzywuzzy==0.18.0
flask-cors==3.0.10
numpy==1.24.3" > requirements.txt

pip install -r requirements.txt

```


## Dependências front-end (já incluídas via CDN no HTML):
- Vue 3 (via unpkg)
- Roboto Font (Google Fonts)

# Iniciar backend
```bash
python server.py
```

# 🖌️ Frontend: abra o index.html no navegador
## Ou use um servidor local:
```bash
npx live-server --port=3000
```
## 🌐 Acesso
```bash
API: http://localhost:5000
Frontend: http://localhost:3000
```

# 🔍 Como Usar

## Interface Web
1. **Digite um termo de busca** no campo de pesquisa:
   - Pode ser: Razão Social, Nome Fantasia, CNPJ ou Registro ANS
   - Exemplo: `saude` ou `12345678901234`

2. **Navegue pelos resultados**:
   - Use os botões `Anterior` e `Próximo`
   - Selecione páginas específicas na paginação

## ⚙️ API REST

### Endpoint Principal
`GET /api/buscar_operadoras`

### Parâmetros
| Parâmetro | Tipo   | Obrigatório | Default | Descrição               |
|-----------|--------|-------------|---------|-------------------------|
| `termo`   | string | Sim         | -       | Termo para busca        |
| `page`    | int    | Não         | 1       | Número da página        |
| `per_page`| int    | Não         | 10      | Itens por página        |

### Exemplo de Uso
```bash
# Busca por "saude" na página 2
curl "http://localhost:5000/api/buscar_operadoras?termo=saude&page=2"
```

### 📡 Coleção Postman
Arquivo da Coleção para baixar e **IMPORTAR**
```bash
📥 operadoras_saude.postman_collection.json
```

## 💈 Como importar no postman 
**Baixe o arquivo JSON da coleção.**

***No Postman:***  Clique em "Import" > "File"

➡️ Selecione o arquivo baixado

**Configure a variável de ambiente ⬇️:**

```bash
base_url: http://localhost:5000 (para desenvolvimento local)
```