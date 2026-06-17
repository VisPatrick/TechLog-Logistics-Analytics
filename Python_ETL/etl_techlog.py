
import mysql.connector
import pandas as pd
import numpy as np
from pathlib import Path
from dotenv import load_dotenv
import os

# DIRETÓRIOS DO PROJETO

BASE_DIR = Path(__file__).resolve().parent.parent

RAW_DIR = BASE_DIR / "Data" / "Raw"
PROCESSED_DIR = BASE_DIR / "Data" / "Processed"
EXPORT_DIR = BASE_DIR / "Data" / "Export"

RAW_DIR.mkdir(parents=True, exist_ok=True)
PROCESSED_DIR.mkdir(parents=True, exist_ok=True)
EXPORT_DIR.mkdir(parents=True, exist_ok=True)

# CONEXÃO COM MYSQL

load_dotenv()

conexao = mysql.connector.connect(
    host=os.getenv('DB_HOST'),
    user=os.getenv('DB_USER'),
    password=os.getenv('DB_PASSWORD'),
    database=os.getenv('DB_NAME')
)

print("Conexão realizada com sucesso!")

# EXTRAÇÃO DOS DADOS

query_produtos = """
SELECT
    p.id_produto,
    p.nome_produto,
    SUM(ir.quantidade_avariada) AS total_avarias
FROM itens_recebimento ir
JOIN produtos p
ON ir.id_produto = p.id_produto
GROUP BY
    p.id_produto,
    p.nome_produto;
"""

query_estoque = """
SELECT
    e.id_estoque,
    p.nome_produto,
    e.quantidade_atual,
    p.estoque_minimo,
    e.localizacao,
    e.ultima_movimentacao
FROM estoque e
JOIN produtos p
ON e.id_produto = p.id_produto;
"""

query_expedicoes = """
SELECT
    id_expedicao,
    numero_pedido,
    data_saida,
    data_entrega,
    status_entrega,
    DATEDIFF(data_entrega, data_saida) AS lead_time
FROM expedicoes;
"""

query_avarias = """
SELECT
    p.nome_produto,
    SUM(ir.quantidade_avariada) AS total_avarias
FROM itens_recebimento ir
JOIN produtos p
ON ir.id_produto = p.id_produto
GROUP BY p.nome_produto;
"""

# DATAFRAMES

df_produtos = pd.read_sql(query_produtos, conexao)

df_estoque = pd.read_sql(query_estoque, conexao)

df_expedicoes = pd.read_sql(query_expedicoes, conexao)

df_avarias = pd.read_sql(query_avarias, conexao)

# VISUALIZAÇÃO INICIAL

print("\n===== PRODUTOS =====")
print(df_produtos.head())

print("\n===== ESTOQUE =====")
print(df_estoque.head())

print("\n===== EXPEDIÇÕES =====")
print(df_expedicoes.head())

print("\n===== AVARIAS =====")
print(df_avarias.head())

# 1. CLASSIFICAÇÃO DE ESTOQUE

df_estoque['status_estoque'] = np.select(
    [
        df_estoque['quantidade_atual'] <= df_estoque['estoque_minimo'],
        df_estoque['quantidade_atual'] <= (df_estoque['estoque_minimo'] * 1.2)
    ],
    [
        'CRÍTICO',
        'ATENÇÃO'
    ],
    default='NORMAL'
)

# 2. CLASSIFICAÇÃO DE LEAD TIME

df_expedicoes['status_prazo'] = np.where(
    df_expedicoes['lead_time'] > 3,
    'ATRASADO',
    'NO PRAZO'
)

# 3. TRATAMENTO DE VALORES NULOS

df_avarias.fillna(0, inplace=True)

# 4. CONVERSÃO DE DATAS

df_expedicoes['data_saida'] = pd.to_datetime(
    df_expedicoes['data_saida']
)

df_expedicoes['data_entrega'] = pd.to_datetime(
    df_expedicoes['data_entrega']
)

# KPIs LOGÍSTICOS

# LEAD TIME MÉDIO

lead_time_medio = df_expedicoes['lead_time'].mean()

print("\n===== KPI =====")
print(f"Lead Time Médio: {lead_time_medio:.2f} dias")

# TOTAL DE PEDIDOS ATRASADOS

pedidos_atrasados = (
    df_expedicoes['status_prazo'] == 'ATRASADO'
).sum()

print(f"Pedidos Atrasados: {pedidos_atrasados}")

# TOTAL DE AVARIAS

total_avarias = df_avarias['total_avarias'].sum()

print(f"Total de Avarias: {total_avarias}")

# PRODUTOS COM ESTOQUE CRÍTICO

estoque_critico = df_estoque[
    df_estoque['status_estoque'] == 'CRÍTICO'
]

print("\n===== ESTOQUE CRÍTICO =====")
print(estoque_critico)

# ANÁLISE DOS PRODUTOS MAIS EXPEDIDOS

query_top_produtos = """
SELECT
    p.nome_produto,
    SUM(ie.quantidade_enviada) AS total_expedido
FROM itens_expedicao ie
JOIN produtos p
ON ie.id_produto = p.id_produto
GROUP BY p.nome_produto
ORDER BY total_expedido DESC;
"""

df_top_produtos = pd.read_sql(
    query_top_produtos,
    conexao
)

print("\n===== PRODUTOS MAIS EXPEDIDOS =====")
print(df_top_produtos)

# EXPORTAÇÃO CSV

df_produtos.to_csv(
    RAW_DIR / 'produtos_raw.csv',
    index=False
)

df_estoque.to_csv(
    PROCESSED_DIR / 'estoque_tratado.csv',
    index=False,
    encoding='utf-8-sig'
)

df_expedicoes.to_csv(
    PROCESSED_DIR / 'expedicoes_tratado.csv',
    index=False,
    encoding='utf-8-sig'
)

df_avarias.to_csv(
    PROCESSED_DIR / 'avarias_tratado.csv',
    index=False,
    encoding='utf-8-sig'
)

df_top_produtos.to_csv(
    PROCESSED_DIR / 'produtos_expedidos.csv',
    index=False,
    encoding='utf-8-sig'
)

print("\nArquivos CSV exportados com sucesso!")git