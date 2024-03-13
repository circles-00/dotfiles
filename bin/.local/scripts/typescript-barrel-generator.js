#!/usr/bin/env node
const { readdirSync, writeFileSync } = require('fs')

const args = process.argv.slice(2)

if (args.length === 0) {
  throw new Error('Please provide a path to a directory')
}

const [currentDirectoryPath] = args
const files = readdirSync(currentDirectoryPath)

let barrelFileContent = ``

files.forEach((file) => {
  const [fileExtension] = file.split('.').reverse()

  const fileParts = file.split(`.${fileExtension}`)
  const [fileName] = fileParts

  if ((fileParts.length === 1 || fileExtension === 'ts' || fileExtension === 'tsx') && fileName !== 'index') {
    const fileContent = `export * from './${fileName}'`
    barrelFileContent += `${fileContent}\n`
  }

  writeFileSync(`${currentDirectoryPath}/index.ts`, barrelFileContent)
})
