# stage 1 - builder
FROM python:3.11-buster AS builder

WORKDIR /app 

RUN pip install --upgrade pip && pip install poetry

COPY pyproject.toml pyproject.toml
COPY poetry.lock poetry.lock

RUN poetry config virtualenvs.create true \
    && poetry config virtualenvs.in-project true \
    && poetry install --no-root --no-interaction --no-ansi 

# stage 2 - app
FROM python:3.11-buster AS app

WORKDIR /app 

COPY --from=builder /app /app

EXPOSE 8000

ENV PATH="/app/.venv/bin:$PATH"

CMD ["uvicorn", "cc_compose.server:app", "--reload", "--host", "0.0.0.0", "--port", "8000"] 



