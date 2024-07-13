# Major System Backend

This is a Node.js backend server for querying vocabulary based on the Major System. It provides a RESTful API for retrieving words associated with specific Major System numbers.

## Features

- RESTful API for querying words by Major System numbers
- SQLite database for efficient storage and retrieval
- Built with Express.js and Prisma ORM
- TypeScript for improved developer experience and type safety

## Prerequisites

- Node.js (v14 or later)
- npm (comes with Node.js)
- Python (for generating the csv file)

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/theUpsider/majorsystem-backend.git
   cd majorsystem-backend
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Set up prisma:
   ```
   npx prisma init --datasource-provider sqlite
   ```
3.1 Migration:
   ```
   npx prisma migrate dev --name init
   ```

   Now a dev.db file should be created in the prisma folder.

4. Generate a csv based on your language specific major system. Replace input_file.txt with the path to your input file, output_file.csv with the desired output file name, and substitution_dict.json with the path to your JSON file containing the substitution dictionary.
    ```
    python prepare_dataset.py datasets/wordlist-german.txt major_system_data.csv substitution_dict.json
    
    ```

5. Populate the database:
   ```
   npm run populate
   ```

## Usage

To start the server in development mode:

```
npm run dev
```


## API Endpoints

- `GET /v1/words/number/:number`: Retrieve words by Major System number

## Credits

The German dictionary used in this project is sourced from [German Dict](https://sourceforge.net/projects/germandict/files/) by janschreiber.

## License

This project is licensed under the MIT License - see below for details.

```
MIT License

Copyright (c) 2023 David Fischer

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```