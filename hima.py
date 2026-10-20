import pandas as pd
from sqlalchemy import create_engine
server = 'localhost\SQLEXPRESS'
database = 'predictive_maintenance_dw'

engine = create_engine(
    f'mssql+pyodbc://@{server}/{database}?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes'
)
query = 'SELECT * FROM silver.integrated_maintenance'
df_integrated = pd.read_sql(query, con=engine)
print(f'إجمالي عدد الصفوف المدمجة: {len(df_integrated)}')
print(df_integrated.head())
