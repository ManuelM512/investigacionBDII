import pandas as pd
from sqlalchemy import create_engine
import os


def connectionEngine(host, db, user, pw):
    engine = create_engine(f"mysql://{user}:{pw}@{host}:3306/{db}")
    return engine


def loadDataToEngine(engine):
    folder = "csv"
    for filename in os.listdir(folder):
        path = os.path.join(folder, filename)
        print(path)
        dataframe = pd.read_csv(path, encoding="ANSI")
        dataframe.to_sql(filename[:-4], engine, if_exists="replace", index=False)


def loadDatabase():
    engine = connectionEngine("localhost", "formulaUno", "root", "root")
    loadDatabase(engine)


def main():
    # loadDatabase() # Utilizado para cargar los datos desde CSV a la BD
    print()
