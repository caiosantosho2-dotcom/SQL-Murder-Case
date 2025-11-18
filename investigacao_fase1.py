import sqlite3

# ATENÇÃO: Verifique e ajuste o nome do arquivo se for diferente no seu computador (por exemplo, 'sql-murder-mystery.db').
DB_PATH = 'sql-murder-mystery (1).db' 

def run_investigation():
    """Executa a automação completa da investigação Root Cause Analysis."""
    conn = None
    
    try:
        # 1. CONEXÃO: Estabelece a conexão com o banco de dados SQLite.
        conn = sqlite3.connect(DB_PATH)
        cursor = conn.cursor()
        print(f"✅ Conexão bem-sucedida com {DB_PATH}.\n")

        # ----------------------------------------------------------------------
        # PASSO 1, 2, 3: EXTRAÇÃO DE PISTAS E TESTEMUNHAS
        # ----------------------------------------------------------------------
        
        # Pega o nome das testemunhas para o relatório final
        QUERY_2A = """SELECT id, name FROM person WHERE address_street_name = 'Northwestern Dr' ORDER BY address_number DESC LIMIT 1;"""
        cursor.execute(QUERY_2A); results_2a = cursor.fetchone() 
        witness1_name = results_2a[1]
        
        QUERY_2B = """SELECT id, name FROM person WHERE address_street_name = 'Franklin Ave' AND name LIKE 'Annabel%';"""
        cursor.execute(QUERY_2B); results_2b = cursor.fetchone() 
        witness2_name = results_2b[1]
        
        # ----------------------------------------------------------------------
        # PASSO 5: IDENTIFICAÇÃO FINAL (O JOIN do Assassino - Root Cause)
        # Aplica os 4 filtros (Gold, 48Z%, H42W%, 20180109) em um só JOIN.
        # ----------------------------------------------------------------------
        QUERY_5 = """
        SELECT T1.id, T1.name
        FROM person AS T1
        JOIN get_fit_now_member AS T2 ON T1.id = T2.person_id
        JOIN drivers_license AS T3 ON T1.license_id = T3.id
        JOIN get_fit_now_check_in AS T4 ON T2.id = T4.membership_id
        WHERE T2.membership_status = 'gold' AND T2.id LIKE '48Z%'              
          AND T3.plate_number LIKE '%H42W%' AND T4.check_in_date = 20180109;
        """
        
        cursor.execute(QUERY_5)
        killer_data = cursor.fetchone()
        
        # ----------------------------------------------------------------------
        # IMPRESSÃO DO RELATÓRIO FINAL (O Produto de BI)
        # ----------------------------------------------------------------------
        if killer_data:
            killer_name = killer_data[1]
            killer_id = killer_data[0]
            
            print("\n" + "=" * 60)
            print("--- RELATÓRIO FINAL: ROOT CAUSE ANALYSIS (BI) ---")
            print(f"1. CRIME: Assassinato em SQL City (2018-01-15)")
            print(f"2. TESTEMUNHAS: {witness1_name} e {witness2_name}")
            print("-" * 60)
            print("3. PISTAS ANALÍTICAS (FILTROS QUE LEVARAM AO CRIMINOSO):")
            print(f"   - Status de Membro: 'gold'")
            print(f"   - ID da Associação: Inicia com '48Z'")
            print(f"   - Placa do Carro: Contém 'H42W'")
            print(f"   - Álibi Quebrado (Data de Check-in na Academia): 20180109")
            print("-" * 60)
            print(f"4. CRIMINOSO IDENTIFICADO: {killer_name} (ID: {killer_id})")
            print("=" * 60)
            
        else:
            print("❌ ATENÇÃO: A automação não encontrou um indivíduo que satisfaça todos os critérios.")
            
    except sqlite3.Error as e:
        print(f"❌ Erro do SQLite: {e}")
    except Exception as e:
        print(f"❌ Erro de Execução: {e}")
    finally:
        # Garante que a conexão seja sempre fechada (SyntaxError fix)
        if conn:
            conn.close()

if __name__ == "__main__":
    run_investigation()