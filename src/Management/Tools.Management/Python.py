import glob
import os
import asyncio

os.chdir("C:\\users\\pauld")


async def get_txt():
    out = await glob.glob("**/*.txt", recursive=True)
    print(out)


async def get_ps1():
    out = await glob.glob("**/*.ps1", recursive=True)
    print(out)


async def get_csv():
    out = await glob.glob("**/*.csv", recursive=True)
    print(out)


async def main():
    out = await asyncio.gather(get_txt, get_ps1, get_csv)
    print(out)


loop = asyncio.get_event_loop()
loop.run_until_complete(main())
