-- FEITO EM Postgres >10.0, no pgAdmin 4

-- Quais as 10 operadoras com maiores despesas em "EVENTOS/ SINISTROS CONHECIDOS OU
-- AVISADOS DE ASSISTÊNCIA A SAÚDE MEDICO HOSPITALAR" no último trimestre?

WITH ultimo_trimestre AS (
    SELECT 
        d.registro_ans,
        COALESCE(o.nome_fantasia, 'NÃO IDENTIFICADA') AS nome_fantasia,
        SUM(d.saldo_final) AS total_despesas
    FROM 
        demonstracoes_contabeis d
    LEFT JOIN 
        operadoras o ON d.registro_ans = o.registro_ans
    WHERE 
        (
            d.descricao_conta LIKE '%EVENTOS/SINISTROS%' OR
            d.descricao_conta LIKE '%SINISTROS CONHECIDOS%'
        )
        AND d.descricao_conta LIKE '%ASSISTÊNCIA MÉDICO-HOSPITALAR%'
        AND d.data >= (SELECT DATE_TRUNC('quarter', MAX(data)) FROM demonstracoes_contabeis)
    GROUP BY 
        d.registro_ans, o.nome_fantasia
)
SELECT 
    registro_ans,
    nome_fantasia AS operadora,
    total_despesas AS despesas_trimestre,
    'R$ ' || 
    REGEXP_REPLACE(
        TRIM(TO_CHAR(total_despesas, '9999999999999999999990D99')),
        '(\d)(?=(\d{3})+(\.|$))', 
        '\1.', 
        'g'
    ) AS despesas_formatadas
FROM 
    ultimo_trimestre
ORDER BY 
    total_despesas DESC
LIMIT 10;





-- Quais as 10 operadoras com maiores despesas nessa categoria no último ano?

WITH despesas_anuais AS (
    SELECT 
        d.registro_ans,
        COALESCE(o.nome_fantasia, 'NÃO IDENTIFICADA') AS operadora,
        SUM(d.saldo_final) AS total_despesas,
        -- Cálculo auxiliar para formatação
        LENGTH(TRUNC(SUM(d.saldo_final))::TEXT) AS digitos
    FROM 
        demonstracoes_contabeis d
    LEFT JOIN 
        operadoras o ON d.registro_ans = o.registro_ans
    WHERE 
        (
            d.descricao_conta LIKE '%EVENTOS/SINISTROS%' OR
            d.descricao_conta LIKE '%SINISTROS CONHECIDOS%'
        )
        AND d.descricao_conta LIKE '%ASSISTÊNCIA MÉDICO-HOSPITALAR%'
        AND d.data >= (SELECT MAX(data) - INTERVAL '1 year' FROM demonstracoes_contabeis)
    GROUP BY 
        d.registro_ans, o.nome_fantasia
)
SELECT 
    registro_ans,
    operadora,
    total_despesas,
    CASE
        WHEN digitos::int > 12 THEN 
            'R$ ' || TRIM(TO_CHAR(total_despesas/1000000000000, '999D99')) || ' trilhões'
        WHEN digitos::int > 9 THEN 
            'R$ ' || TRIM(TO_CHAR(total_despesas/1000000000, '999D99')) || ' bilhões'
        WHEN digitos::int > 6 THEN 
            'R$ ' || TRIM(TO_CHAR(total_despesas/1000000, '999D99')) || ' milhões'
        ELSE 
            'R$ ' || TRIM(TO_CHAR(total_despesas, '999G999D99'))
    END AS despesas_formatadas
FROM 
    despesas_anuais
ORDER BY 
    total_despesas DESC
LIMIT 10;

