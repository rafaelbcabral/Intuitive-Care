const { createApp } = Vue;

createApp({
    data() {
        return {
          isHydrating: true,
            termoBusca: '',
            resultados: [],
            totalResultados: 0,
            totalPaginas: 0,
            carregando: false,
            erro: null,
            paginaAtual: 1,
            itensPorPagina: 10,
            maxPaginasVisiveis: 5
        };
    },
    mounted() {
      this.isHydrating = false;
  },
    computed: {
        paginasVisiveis() {
            const metade = Math.floor(this.maxPaginasVisiveis / 2);
            let inicio = Math.max(1, this.paginaAtual - metade);
            let fim = Math.min(this.totalPaginas, inicio + this.maxPaginasVisiveis - 1);
            
            if (fim - inicio + 1 < this.maxPaginasVisiveis) {
                inicio = Math.max(1, fim - this.maxPaginasVisiveis + 1);
            }
            
            const paginas = [];
            for (let i = inicio; i <= fim; i++) {
                paginas.push(i);
            }
            return paginas;
        }
    },
    methods: {
        async buscarOperadoras() {
            this.erro = null;
            if (!this.termoBusca.trim()) {
                this.erro = 'Por favor, digite um termo para buscar';
                return;
            }

            this.carregando = true;
            try {
                const resposta = await fetch(
                    `http://localhost:5000/api/buscar_operadoras?termo=${
                        encodeURIComponent(this.termoBusca)
                    }&page=${
                        this.paginaAtual
                    }&per_page=${
                        this.itensPorPagina
                    }`
                );
                
                if (!resposta.ok) {
                    throw new Error('Erro ao buscar operadoras');
                }

                const dados = await resposta.json();
                this.resultados = dados.resultados || [];
                this.totalResultados = dados.total_resultados || 0;
                this.totalPaginas = dados.total_paginas || 1;
                
                if (this.resultados.length === 0) {
                    this.erro = `Nenhum resultado encontrado para "${this.termoBusca}"`;
                }
            } catch (erro) {
                this.erro = `Erro: ${erro.message}`;
                console.error(erro);
            } finally {
                this.carregando = false;
            }
        },
        
        mudarPagina(novaPagina) {
            if (novaPagina < 1 || novaPagina > this.totalPaginas) return;
            this.paginaAtual = novaPagina;
            this.buscarOperadoras();
        }
    }
}).mount("#app");