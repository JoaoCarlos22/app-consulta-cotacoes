# 📈 Aplicativo Mobile de Consulta de Cotações Financeiras

Este é um aplicativo Flutter que exibe cotações financeiras atualizadas, permitindo ao usuário visualizar uma moeda base e a 
lista de outras moedas com suas respectivas taxas de câmbio em tempo real.

- **API Utilizada:**  [ExchangeRate-API](https://www.exchangerate-api.com/)

## 🚀 Tecnologias Utilizadas

- **Flutter**: Framework para desenvolvimento mobile multi-plataforma.
- **Dart**: Linguagem de programação.
- **http**: Pacote para realizar requisições HTTP à API.
- **provider**: Gerenciamento de estado para disponibilizar os dados das cotações em toda a aplicação.
- **intl**: Pacote para internacionalização e formatação de datas e números.

## 📁 Estrutura do Projeto

O projeto segue uma estrutura de pastas modular, focando na separação de preocupações para facilitar a manutenção e escalabilidade:

```
lib/
| -- main.dart
| -- models/
|      |-- Quotes.dart
|
| -- providers/
|      |-- QuotesProvider.dart
|
| -- repositories/
|      |-- quotesRepository.dart
|
| -- screen/
       |-- Details.dart
test/
| -- quotesParsingTest.dart
```

## 🛠️ Como Iniciar o Projeto

Siga estas instruções para configurar e rodar o projeto em sua máquina local:

**Pré-requisitos**

- Flutter SDK instalado.
- Um editor de código (VS Code, Android Studio).
- Um emulador Android/iOS configurado ou um dispositivo físico.

**Instalação**

**1. Clone o repositório:**

```
git clone https://github.com/JoaoCarlos22/app-consulta-cotacoes.git
cd app_consulta_cotacoes
```

**2. Instale as dependências:**

```
flutter pub get
```

**3. Verifique as permissões de internet (Android):**

Certifique-se de que no arquivo android/app/src/main/AndroidManifest.xml, a seguinte linha esteja presente dentro da tag <manifest>:

```
<uses-permission android:name="android.permission.INTERNET"/>
```

**4. Rode o aplicativo:**

Após a instalação das dependências, você pode rodar o aplicativo:

```
flutter run
```

**5. Rode os testes**

Os testes unitários verificam a lógica de processamento dos dados da API de forma isolada.

```
flutter test test/quotesParsingTest.dart
```
