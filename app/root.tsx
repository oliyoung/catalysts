import {
  Links,
  Meta,
  Outlet,
  Scripts,
  ScrollRestoration,
  useLoaderData,
} from "@remix-run/react";
import "./tailwind.css";
import prisma from "prisma/db";
import { json } from "@remix-run/node";
import { Link } from "@remix-run/react";

export function Layout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="en">
      <head>
        <meta charSet="utf-8" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <Meta />
        <Links />
      </head>
      <body className="bg-slate-900">
        {children}
        <ScrollRestoration />
        <Scripts />
      </body>
    </html>
  );
}

export const loader = async () => {
  const companies = await prisma.company.findMany({
    take: 10,
    include: {
      catalysts: true
    }
  })
  return json({ companies });
};

export default function App() {
  const { companies } = useLoaderData<typeof loader>();

  return <div className="grid grid-cols-12 gap-4 py-2">
    <div className="col-span-3 px-4 flex flex-col gap-4">
      {companies?.map((company, index) =>
        <Link
          to={`/companies/${company.id}`}
          key={index}
          className="p-2 hover:bg-slate-100 flex-row flex">
          <div className="flex-1">
            <div className="text-slate-900">
              {company.name}
            </div>
          </div>
          <div>
            {company.catalysts.length}
          </div>
        </Link>
      )
      }
      <Link to="/reports/new">New Report</Link>
    </div >
    <div className="col-span-9 px-4">
      <Outlet />
    </div>
  </div >
}
