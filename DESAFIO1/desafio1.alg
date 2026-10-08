tipo
   TEntrega = registro
      codigo: inteiro
      destinatario: caractere
      origem: inteiro
      destino: inteiro
      peso: real
      valorMercadoria: real
      prioridade: inteiro
      distancia: inteiro
      status: inteiro
      custo: real
   fimregistro
var
   MAX_ENTREGAS, MAX_REGIOES, URGENTE, PRIORITARIA, NORMAL, AGUARDANDO, EM_TRANSPORTE, ENTREGUE, PESO_FAIXA1, PESO_FAIXA2, PESO_FAIXA3: inteiro
   VALOR_KM, TAXA_PESO2, TAXA_PESO3, TAXA_PESO4, TAXA_PRIORITARIA, TAXA_URGENTE: real
   entregas: vetor[1..30] de TEntrega
   distancias: vetor[1..5,1..5] de inteiro
   percurso: vetor[1..5] de inteiro
   quantidade: inteiro
   opcao, confirmacao: inteiro

funcao nomeRegiao(cod: inteiro): caractere
inicio
   escolha cod
      caso 1
         retorne "Centro"
      caso 2
         retorne "Norte"
      caso 3
         retorne "Sul"
      caso 4
         retorne "Leste"
      caso 5
         retorne "Oeste"
      outrocaso
         retorne "Invalida"
   fimescolha
fimfuncao

funcao nomePrioridade(cod: inteiro): caractere
inicio
   escolha cod
      caso 1
         retorne "Urgente"
      caso 2
         retorne "Prioritaria"
      outrocaso
         retorne "Normal"
   fimescolha
fimfuncao

funcao nomeStatus(cod: inteiro): caractere
inicio
   escolha cod
      caso 1
         retorne "Aguardando"
      caso 2
         retorne "Em transporte"
      outrocaso
         retorne "Entregue"
   fimescolha
fimfuncao

procedimento inicializarMatriz
inicio
   distancias[1,1] <- 0
   distancias[1,2] <- 12
   distancias[1,3] <- 15
   distancias[1,4] <- 10
   distancias[1,5] <- 14
   distancias[2,1] <- 12
   distancias[2,2] <- 0
   distancias[2,3] <- 25
   distancias[2,4] <- 18
   distancias[2,5] <- 20
   distancias[3,1] <- 15
   distancias[3,2] <- 25
   distancias[3,3] <- 0
   distancias[3,4] <- 16
   distancias[3,5] <- 19
   distancias[4,1] <- 10
   distancias[4,2] <- 18
   distancias[4,3] <- 16
   distancias[4,4] <- 0
   distancias[4,5] <- 22
   distancias[5,1] <- 14
   distancias[5,2] <- 20
   distancias[5,3] <- 19
   distancias[5,4] <- 22
   distancias[5,5] <- 0
fimprocedimento

// Retorna zero se o codigo nao existir.
funcao localizarEntrega(cod: inteiro): inteiro
var
   i, encontrado: inteiro
inicio
   encontrado <- 0
   para i de 1 ate quantidade faca
      se entregas[i].codigo = cod entao
         encontrado <- i
      fimse
   fimpara
   retorne encontrado
fimfuncao

// Os percentuais de peso e prioridade sao somados ao custo-base.
funcao calcularCusto(km: inteiro; kg: real; prio: inteiro): real
var
   adicionalPeso, adicionalPrioridade, base: real
inicio
   base <- km * VALOR_KM
   adicionalPeso <- 0
   adicionalPrioridade <- 0
   se kg > PESO_FAIXA3 entao
      adicionalPeso <- TAXA_PESO4
   senao
      se kg > PESO_FAIXA2 entao
         adicionalPeso <- TAXA_PESO3
      senao
         se kg > PESO_FAIXA1 entao
            adicionalPeso <- TAXA_PESO2
         fimse
      fimse
   fimse
   escolha prio
      caso 1
         adicionalPrioridade <- TAXA_URGENTE
      caso 2
         adicionalPrioridade <- TAXA_PRIORITARIA
   fimescolha
   retorne base * (1 + adicionalPeso + adicionalPrioridade)
fimfuncao

procedimento exibirEntrega(indice: inteiro)
inicio
   escreval("------------------------------")
   escreval("Codigo: ", entregas[indice].codigo)
   escreval("Destinatario: ", entregas[indice].destinatario)
   escreval("Origem: ", nomeRegiao(entregas[indice].origem))
   escreval("Destino: ", nomeRegiao(entregas[indice].destino))
   escreval("Peso (kg): ", entregas[indice].peso:0:2)
   escreval("Valor mercadoria (R$): ", entregas[indice].valorMercadoria:0:2)
   escreval("Prioridade: ", nomePrioridade(entregas[indice].prioridade))
   escreval("Distancia (km): ", entregas[indice].distancia)
   escreval("Status: ", nomeStatus(entregas[indice].status))
   escreval("Custo estimado (R$): ", entregas[indice].custo:0:2)
fimprocedimento

procedimento cadastrarEntrega
var
   cod, ori, dest, prio: inteiro
   nome: caractere
   kg, valor: real
inicio
   se quantidade >= MAX_ENTREGAS entao
      escreval("ERRO: capacidade maxima de entregas atingida.")
   senao
      escreva("Codigo positivo da entrega: ")
      leia(cod)
      enquanto (cod <= 0) ou (localizarEntrega(cod) <> 0) faca
         escreval("ERRO: codigo invalido ou duplicado.")
         escreva("Informe outro codigo positivo: ")
         leia(cod)
      fimenquanto
      escreva("Nome/descricao do destinatario: ")
      leia(nome)
      escreval("Regioes: 1-Centro 2-Norte 3-Sul 4-Leste 5-Oeste")
      escreva("Origem: ")
      leia(ori)
      enquanto (ori < 1) ou (ori > MAX_REGIOES) faca
         escreval("ERRO: origem inexistente.")
         leia(ori)
      fimenquanto
      escreva("Destino: ")
      leia(dest)
      enquanto (dest < 1) ou (dest > MAX_REGIOES) ou (dest = ori) faca
         escreval("ERRO: destino inexistente ou igual a origem.")
         leia(dest)
      fimenquanto
      escreva("Peso em kg (maior que zero): ")
      leia(kg)
      enquanto kg <= 0 faca
         escreval("ERRO: peso deve ser maior que zero.")
         leia(kg)
      fimenquanto
      escreva("Valor da mercadoria (R$): ")
      leia(valor)
      enquanto valor < 0 faca
         escreval("ERRO: valor nao pode ser negativo.")
         leia(valor)
      fimenquanto
      escreva("Prioridade (1-Urgente 2-Prioritaria 3-Normal): ")
      leia(prio)
      enquanto (prio < URGENTE) ou (prio > NORMAL) faca
         escreval("ERRO: prioridade inexistente.")
         leia(prio)
      fimenquanto
      quantidade <- quantidade + 1
      entregas[quantidade].codigo <- cod
      entregas[quantidade].destinatario <- nome
      entregas[quantidade].origem <- ori
      entregas[quantidade].destino <- dest
      entregas[quantidade].peso <- kg
      entregas[quantidade].valorMercadoria <- valor
      entregas[quantidade].prioridade <- prio
      entregas[quantidade].distancia <- distancias[ori,dest]
      entregas[quantidade].status <- AGUARDANDO
      entregas[quantidade].custo <- calcularCusto(distancias[ori,dest],kg,prio)
      escreval("Entrega cadastrada com sucesso!")
      exibirEntrega(quantidade)
   fimse
fimprocedimento

procedimento listarEntregas
var
   i: inteiro
inicio
   se quantidade = 0 entao
      escreval("Nenhuma entrega cadastrada.")
   senao
      para i de 1 ate quantidade faca
         exibirEntrega(i)
      fimpara
   fimse
fimprocedimento

procedimento consultarEntrega
var
   cod, indiceBusca: inteiro
inicio
   escreva("Codigo para consulta: ")
   leia(cod)
   indiceBusca <- localizarEntrega(cod)
   se indiceBusca = 0 entao
      escreval("Entrega nao encontrada.")
   senao
      exibirEntrega(indiceBusca)
   fimse
fimprocedimento

// Comparacao: prioridade menor, valor maior, peso maior, codigo menor.
funcao vemAntes(a, b: inteiro): logico
inicio
   se entregas[a].prioridade <> entregas[b].prioridade entao
      retorne entregas[a].prioridade < entregas[b].prioridade
   senao
      se entregas[a].valorMercadoria <> entregas[b].valorMercadoria entao
         retorne entregas[a].valorMercadoria > entregas[b].valorMercadoria
      senao
         se entregas[a].peso <> entregas[b].peso entao
            retorne entregas[a].peso > entregas[b].peso
         senao
            retorne entregas[a].codigo < entregas[b].codigo
         fimse
      fimse
   fimse
fimfuncao

// Selection sort somente entre as entregas aguardando.
// O vetor de registros original nao e alterado.
procedimento exibirFila
var
   indices: vetor[1..30] de inteiro
   n, i, j, melhor, aux: inteiro
inicio
   n <- 0
   para i de 1 ate quantidade faca
      se entregas[i].status = AGUARDANDO entao
         n <- n + 1
         indices[n] <- i
      fimse
   fimpara
   se n = 0 entao
      escreval("Nao ha entregas aguardando despacho.")
   senao
      para i de 1 ate n-1 faca
         melhor <- i
         para j de i+1 ate n faca
      se vemAntes(indices[j], indices[melhor]) entao
               melhor <- j
            fimse
         fimpara
         aux <- indices[i]
         indices[i] <- indices[melhor]
         indices[melhor] <- aux
      fimpara
      escreval("FILA DE DESPACHO - ", n, " entrega(s)")
      para i de 1 ate n faca
         escreval("Posicao ", i)
         exibirEntrega(indices[i])
      fimpara
   fimse
fimprocedimento

procedimento iniciarTransporte
var
   cod, indiceBusca: inteiro
inicio
   escreva("Codigo da entrega a iniciar: ")
   leia(cod)
   indiceBusca <- localizarEntrega(cod)
   se indiceBusca = 0 entao
      escreval("Entrega nao encontrada.")
   senao
      se entregas[indiceBusca].status = AGUARDANDO entao
         entregas[indiceBusca].status <- EM_TRANSPORTE
         escreval("Transporte iniciado com sucesso.")
      senao
         escreval("ERRO: apenas entregas aguardando podem iniciar transporte.")
      fimse
   fimse
fimprocedimento

procedimento finalizarEntrega
var
   cod, indiceBusca: inteiro
inicio
   escreva("Codigo da entrega a finalizar: ")
   leia(cod)
   indiceBusca <- localizarEntrega(cod)
   se indiceBusca = 0 entao
      escreval("Entrega nao encontrada.")
   senao
      se entregas[indiceBusca].status = EM_TRANSPORTE entao
         entregas[indiceBusca].status <- ENTREGUE
         escreval("Entrega finalizada com sucesso.")
      senao
         escreval("ERRO: apenas entregas em transporte podem ser finalizadas.")
      fimse
   fimse
fimprocedimento

procedimento exibirMatriz
var
   i, j, maior, menor, soma, pares: inteiro
inicio
   maior <- 0
   menor <- 999999
   soma <- 0
   pares <- 0
   escreval("MATRIZ DE DISTANCIAS (km)")
   escreval("        Centro Norte Sul Leste Oeste")
   para i de 1 ate MAX_REGIOES faca
      escreva(nomeRegiao(i), " : ")
      para j de 1 ate MAX_REGIOES faca
         escreva(distancias[i,j]:4)
         se i <> j entao
            se distancias[i,j] > maior entao
               maior <- distancias[i,j]
            fimse
            se distancias[i,j] < menor entao
               menor <- distancias[i,j]
            fimse
            soma <- soma + distancias[i,j]
            pares <- pares + 1
         fimse
      fimpara
      escreval("")
   fimpara
   escreval("Maior distancia: ", maior, " km")
   escreval("Menor distancia nao nula: ", menor, " km")
   escreval("Media entre regioes: ", (soma / pares):0:2, " km")
fimprocedimento

procedimento exibirEstatisticas
var
   i, r, qtdAg, qtdTrans, qtdEnt, qtdUrg, qtdPri, qtdNor: inteiro
   maiorValor, maiorPeso, maiorDist, regiaoMaior, maxRecebidas: inteiro
   recebidas: vetor[1..5] de inteiro
   somaPeso, somaValor, somaCusto, pesoEntregue: real
inicio
   se quantidade = 0 entao
      escreval("Nenhuma entrega cadastrada para estatisticas.")
   senao
      qtdAg <- 0
      qtdTrans <- 0
      qtdEnt <- 0
      qtdUrg <- 0
      qtdPri <- 0
      qtdNor <- 0
      somaPeso <- 0
      somaValor <- 0
      somaCusto <- 0
      pesoEntregue <- 0
      maiorValor <- 1
      maiorPeso <- 1
      maiorDist <- 1
      para r de 1 ate MAX_REGIOES faca
         recebidas[r] <- 0
      fimpara
      para i de 1 ate quantidade faca
         escolha entregas[i].status
            caso 1
               qtdAg <- qtdAg + 1
            caso 2
               qtdTrans <- qtdTrans + 1
            caso 3
               qtdEnt <- qtdEnt + 1
               pesoEntregue <- pesoEntregue + entregas[i].peso
         fimescolha
         escolha entregas[i].prioridade
            caso 1
               qtdUrg <- qtdUrg + 1
            caso 2
               qtdPri <- qtdPri + 1
            caso 3
               qtdNor <- qtdNor + 1
         fimescolha
         somaPeso <- somaPeso + entregas[i].peso
         somaValor <- somaValor + entregas[i].valorMercadoria
         somaCusto <- somaCusto + entregas[i].custo
         recebidas[entregas[i].destino] <- recebidas[entregas[i].destino] + 1
         se entregas[i].valorMercadoria > entregas[maiorValor].valorMercadoria entao
            maiorValor <- i
         fimse
         se entregas[i].peso > entregas[maiorPeso].peso entao
            maiorPeso <- i
         fimse
         se entregas[i].distancia > entregas[maiorDist].distancia entao
            maiorDist <- i
         fimse
      fimpara
      regiaoMaior <- 1
      maxRecebidas <- recebidas[1]
      para r de 2 ate MAX_REGIOES faca
         se recebidas[r] > maxRecebidas entao
            maxRecebidas <- recebidas[r]
            regiaoMaior <- r
         fimse
      fimpara
      escreval("========== ESTATISTICAS ==========")
      escreval("Total cadastradas: ", quantidade)
      escreval("Aguardando: ", qtdAg)
      escreval("Em transporte: ", qtdTrans)
      escreval("Entregues: ", qtdEnt)
      escreval("Urgentes: ", qtdUrg)
      escreval("Prioritarias: ", qtdPri)
      escreval("Normais: ", qtdNor)
      escreval("Peso total cadastrado (kg): ", somaPeso:0:2)
      escreval("Peso total entregue (kg): ", pesoEntregue:0:2)
      escreval("Peso medio (kg): ", (somaPeso/quantidade):0:2)
      escreval("Valor total mercadorias (R$): ", somaValor:0:2)
      escreval("Valor medio mercadorias (R$): ", (somaValor/quantidade):0:2)
      escreval("Custo total estimado (R$): ", somaCusto:0:2)
      escreval("Custo medio estimado (R$): ", (somaCusto/quantidade):0:2)
      escreval("Maior valor - codigo: ", entregas[maiorValor].codigo, " / R$ ", entregas[maiorValor].valorMercadoria:0:2)
      escreval("Maior peso - codigo: ", entregas[maiorPeso].codigo, " / kg ", entregas[maiorPeso].peso:0:2)
      escreval("Maior distancia - codigo: ", entregas[maiorDist].codigo, " / km ", entregas[maiorDist].distancia)
      escreval("Regiao com mais destinos: ", nomeRegiao(regiaoMaior), " (", maxRecebidas, ")")
      para r de 1 ate MAX_REGIOES faca
         escreval("  ", nomeRegiao(r), ": ", recebidas[r], " entrega(s)")
      fimpara
   fimse
fimprocedimento

// Caso-base: a ultima regiao nao possui proximo trecho.
funcao distanciaRecursiva(indice: inteiro; n: inteiro): inteiro
inicio
   se indice >= n entao
      retorne 0
   senao
      retorne distancias[percurso[indice], percurso[indice+1]] + distanciaRecursiva(indice+1, n)
   fimse
fimfuncao
procedimento calcularPercurso
var
   n, i, regiao: inteiro
inicio
   escreva("Quantidade de regioes do percurso (2 a 5): ")
   leia(n)
   enquanto (n < 2) ou (n > MAX_REGIOES) faca
      escreval("ERRO: informe entre 2 e 5 regioes.")
      leia(n)
   fimenquanto
   escreval("1-Centro 2-Norte 3-Sul 4-Leste 5-Oeste")
   para i de 1 ate n faca
      escreva("Regiao ", i, ": ")
      leia(regiao)
      enquanto (regiao < 1) ou (regiao > MAX_REGIOES) faca
         escreval("ERRO: regiao inexistente.")
         leia(regiao)
      fimenquanto
      percurso[i] <- regiao
   fimpara
   escreval("Percurso informado:")
   para i de 1 ate n faca
      escreva(nomeRegiao(percurso[i]))
      se i < n entao
         escreva(" -> ")
      fimse
   fimpara
   escreval("")
   escreval("Distancia total recursiva: ", distanciaRecursiva(1,n), " km")
fimprocedimento

inicio
   MAX_ENTREGAS <- 30
   MAX_REGIOES <- 5
   URGENTE <- 1
   PRIORITARIA <- 2
   NORMAL <- 3
   AGUARDANDO <- 1
   EM_TRANSPORTE <- 2
   ENTREGUE <- 3
   VALOR_KM <- (250 / 100)
   PESO_FAIXA1 <- 5
   PESO_FAIXA2 <- 20
   PESO_FAIXA3 <- 50
   TAXA_PESO2 <- (10 / 100)
   TAXA_PESO3 <- (20 / 100)
   TAXA_PESO4 <- (35 / 100)
   TAXA_PRIORITARIA <- (15 / 100)
   TAXA_URGENTE <- (30 / 100)
   quantidade <- 0
   inicializarMatriz()
   repita
      escreval("")
      escreval("LOGIFAST - SISTEMA DE GERENCIAMENTO DE ENTREGAS")
      escreval("1. Cadastrar entrega")
      escreval("2. Listar entregas")
      escreval("3. Consultar entrega")
      escreval("4. Exibir fila de despacho")
      escreval("5. Iniciar transporte")
      escreval("6. Finalizar entrega")
      escreval("7. Exibir matriz de distancias")
      escreval("8. Exibir estatisticas")
      escreval("9. Calcular percurso recursivamente")
      escreval("10. Encerrar sistema")
      escreva("Escolha uma opcao: ")
      leia(opcao)
      escolha opcao
         caso 1
            cadastrarEntrega()
         caso 2
            listarEntregas()
         caso 3
            consultarEntrega()
         caso 4
            exibirFila()
         caso 5
            iniciarTransporte()
         caso 6
            finalizarEntrega()
         caso 7
            exibirMatriz()
         caso 8
            exibirEstatisticas()
         caso 9
            calcularPercurso()
         caso 10
            escreval("Sistema encerrado.")
         outrocaso
            escreval("ERRO: opcao invalida no menu.")
      fimescolha
      se opcao <> 10 entao
         escreval("")
         escreva("Digite 0 e pressione ENTER para voltar ao menu: ")
         leia(confirmacao)
      fimse
   ate opcao = 10
fimalgoritmo

