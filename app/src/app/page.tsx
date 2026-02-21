"use client";

import { useExampleStore } from "@/stores/example-store";

export default function Home() {
  const { count, increment, decrement, reset } = useExampleStore();

  return (
    <main className="flex min-h-screen flex-col items-center justify-center gap-8 p-8">
      <h1 className="text-4xl font-bold">Domus Hackathon Starter Kit</h1>
      <p className="text-lg text-gray-600">Your hackathon project starts here.</p>

      <div className="flex flex-col items-center gap-4 rounded-xl border border-gray-200 p-8">
        <p className="text-sm text-gray-500">Zustand Store Demo</p>
        <p className="text-6xl font-mono">{count}</p>
        <div className="flex gap-2">
          <button
            type="button"
            onClick={decrement}
            className="rounded-lg bg-gray-200 px-4 py-2 hover:bg-gray-300"
          >
            -
          </button>
          <button
            type="button"
            onClick={reset}
            className="rounded-lg bg-gray-200 px-4 py-2 hover:bg-gray-300"
          >
            Reset
          </button>
          <button
            type="button"
            onClick={increment}
            className="rounded-lg bg-gray-200 px-4 py-2 hover:bg-gray-300"
          >
            +
          </button>
        </div>
      </div>

      <div className="mt-8 text-center text-sm text-gray-400">
        <p>Next.js + React + TypeScript + Tailwind</p>
        <p>Zustand + TanStack Query + Drizzle + PostgreSQL</p>
      </div>
    </main>
  );
}
