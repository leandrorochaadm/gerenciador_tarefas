# Gerenciador de Tarefas

Este é um aplicativo Flutter para gerenciamento de tarefas. Ele permite criar, editar, marcar como concluídas ou excluir tarefas. Todas as tarefas ficam no seu celular, e não precisa usar a internet.

---

## **Pré-requisitos**

Antes de começar, verifique se você possui os seguintes itens instalados no seu sistema:

1. **Flutter** na versão **3.24.5**.
2. **Dart** na versão **3.5.4** (instalado com o Flutter).
3. **Git** para clonar o repositório.
4. **Editor de Código** (recomendado: [VS Code](https://code.visualstudio.com/) ou [Android Studio](https://developer.android.com/studio)).

---

## **Instalando o Flutter 3.24.5**

### **Passos para Instalação:**

1. **Baixe o Flutter**
    - Acesse o repositório oficial do Flutter no GitHub: [https://github.com/flutter/flutter.git](https://github.com/flutter/flutter.git).
    - Clone o repositório na branch `stable`:
      ```bash
      git clone https://github.com/flutter/flutter.git -b stable
      ```
    - Certifique-se de que o diretório **`flutter`** está no `PATH` do sistema.


3. **Verifique a Instalação**
    - Execute o comando abaixo para verificar se o Flutter está instalado corretamente:
      ```bash
      flutter doctor
      ```

4. **Instale Dependências**
    - Instale as dependências específicas para sua plataforma:
        - **Linux/Windows:** Siga as instruções no terminal fornecidas pelo `flutter doctor`.
        - **MacOS:** Certifique-se de ter o **Xcode** instalado e configurado.

---

## **Clonando e Rodando o Projeto**

### **Passos para Configurar o Projeto:**



1. **Instale as Dependências**
    - Dentro do diretório do projeto, execute:
      ```bash
      flutter pub get
      ```

2. **Execute no Emulador ou Dispositivo Físico**
    - Certifique-se de que um dispositivo está conectado e listado:
      ```bash
      flutter devices
      ```
    - Execute o aplicativo:
      ```bash
      flutter run
      ```

3. **Opções Avançadas**
    - Para construir o aplicativo para Android:
      ```bash
      flutter build apk
      ```
    - Para iOS (exige MacOS e Xcode configurado):
      ```bash
      flutter build ios
      ```

---

## **Estrutura do Projeto**

- **`/lib`**: Contém o código principal do aplicativo.
    - **`/data`**: Lida com fontes de dados e repositórios.
    - **`/domain`**: Contém entidades e casos de uso.
    - **`/presentation`**: Contém controladores, estados e interfaces do usuário.
- **`pubspec.yaml`**: Arquivo de dependências do Flutter.
- **`README.md`**: Documentação do projeto.

---

## **Funcionalidades**

1. **Adicionar Tarefa**: Crie uma nova tarefa com título e descrição.
2. **Editar Tarefa**: Atualize título, descrição e status.
3. **Excluir Tarefa**: Remova tarefas indesejadas.
4. **Marcar como Concluída**: Altere o status da tarefa.

