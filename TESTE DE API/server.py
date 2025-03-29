from flask import Flask, request, jsonify
import pandas as pd
from fuzzywuzzy import fuzz
from flask_cors import CORS
import urllib.parse
import numpy as np

app = Flask(__name__)
CORS(app)

df = pd.read_csv('Relatorio_cadop.csv', encoding='utf-8', delimiter=';').fillna('')

@app.route('/api/buscar_operadoras', methods=['GET'])
def buscar_operadoras():
    try:
        termo = urllib.parse.unquote(request.args.get('termo', '')).strip()
        if not termo:
            return jsonify({"error": "Parâmetro 'termo' é obrigatório"}), 400
        
        page = int(request.args.get('page', 1))
        per_page = int(request.args.get('per_page', 10))  # Itens por página
        
        def calcular_relevancia(row):
            campos = [
                str(row.get('Razao_Social', '')),
                str(row.get('Nome_Fantasia', '')),
                str(row.get('CNPJ', '')),
                str(row.get('Registro_ANS', ''))
            ]
            return fuzz.token_set_ratio(termo.lower(), ' '.join(campos).lower())

        df['Relevancia'] = df.apply(calcular_relevancia, axis=1)
        resultados = df[df['Relevancia'] > 50].sort_values('Relevancia', ascending=False)
        
        # Converte NaN para string vazia em todo o DataFrame (NaN por "" na tabela)
        resultados = resultados.replace([np.nan, None], '')
        
        total_resultados = len(resultados)
        total_paginas = max(1, (total_resultados + per_page - 1) // per_page)
        
        page = max(1, min(page, total_paginas))
        
        start_idx = (page - 1) * per_page
        end_idx = start_idx + per_page
        resultados_paginados = resultados.iloc[start_idx:end_idx]
        
        return jsonify({
            "termo_busca": termo,
            "resultados": resultados_paginados.to_dict(orient='records'),
            "total_resultados": total_resultados,
            "total_paginas": total_paginas,
            "pagina_atual": page
        })

    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)