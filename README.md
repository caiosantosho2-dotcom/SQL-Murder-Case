Que Aprendi Resolvendo um Caso Criminal com SQL (Além de Encontrar o Assassino)

Encontrei o SQL Murder Mystery procurando uma forma de praticar consultas SQL. Mas enquanto montava as queries para resolver o caso, comecei a pensar: e se eu fosse além?
Decidi que não ia só encontrar o assassino. Queria explorar os dados com uma visão de negócio — olhar para as mesmas tabelas e tentar responder perguntas que agregariam valor em uma empresa real.

Quando abri o banco de dados, vi que tinha apenas 7 tabelas e um único caso de assassinato. Não era o cenário ideal para fazer análises profundas de padrões.
Mas isso me fez repensar a abordagem: trabalhei a lógica de negócio em cima do que tinha disponível. Nem sempre temos os dados perfeitos, mas precisamos entregar insights mesmo assim.

A metodologia em três etapas

FASE 1: Investigação
Comecei pelo registro de ocorrências e entrevistas policiais. Extraí três pistas textuais: academia, ID de membro começando com 48Z, e placa terminando em H42W.
O desafio? Conectar 6 tabelas diferentes (cadastro de pessoas, carteiras de motorista, membros da academia, check-ins) para cruzar essas informações. Usei JOINs estratégicos e filtros em sequência até isolar o único indivíduo que atendia todos os critérios: Jeremy Bowers.

FASE 2: Inteligência de Negócio
Peguei as mesmas tabelas da investigação e remodelei a lógica para responder perguntas de negócio. Em vez de "quem é o culpado?", passei a perguntar "qual horário tem mais movimento?" ou "qual região tem mais risco?".
Transformei dados de check-in em análise de horários de pico. Transformei endereços em mapa de risco geográfico. Transformei critérios de suspeita em sistema de pontuação (lead scoring).

FASE 3: Automação com IA como parceira
Aqui está um ponto importante: usei o Gemini para gerar os códigos SQL e Python, mas a estratégia foi toda minha.
Eu conduzia as análises definindo:
Quais tabelas consultar
Quais colunas cruzar
Como eu queria o resultado formatado
Que perguntas de negócio responder
O Gemini acelerou a escrita do código, mas a modelagem, os JOINs estratégicos e a interpretação dos dados vieram da minha análise. É assim que vejo IA no trabalho: uma ferramenta que amplifica produtividade, mas não substitui o raciocínio analítico.

Os 4 insights que entreguei
Cada análise resolve um problema real de negócio:
1. Root Cause Analysis automatizada: Consolidei todas as pistas críticas (Status Gold, ID iniciando com 48Z, Placa H42W, presença no dia 09/01/2018) em um relatório executivo limpo. O tipo de entrega que economiza horas de reunião.
2. Otimização de recursos: Descobri que clientes Gold lotam a academia às 10h, enquanto Silver preferem 11h. Tradução para negócios: dados para alocar melhor a equipe nos horários de pico e melhorar a experiência do cliente premium.
3. Análise de risco geográfico: Franklin Av. concentra o maior número de ocorrências policiais da cidade. Esse tipo de segmentação geográfica funciona para mapear áreas de risco, concentração de vendas ou oportunidades inexploradas.
4. Score de suspeita (meu modelo preditivo simplificado): Criei um sistema de pontuação usando CASE WHEN: Placa correta (50 pts), Status Gold (20 pts), etc. Jeremy Bowers marcou 100 pontos e era o culpado. A mesma lógica que usamos para lead scoring ou classificação de risco de crédito.

E por que estou compartilhando isso?

Estou estudando análise de dados e aplicando nas minha experiências. Este projeto mostra um pouco de como penso: dados são ferramentas para resolver problemas de negócio.
