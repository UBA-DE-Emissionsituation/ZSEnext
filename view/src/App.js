// Import everything needed to use the `useQuery` hook
import { useQuery, gql } from '@apollo/client';

const GET_FUELS = gql`
  query ListFuels {
    fuel(order_by: {label_en: asc}) {
      id
      category
      label_en
      label_de
      fossil
    }
  }
`;

const GET_REGIONS = gql`
  query ListRegions {
    region(order_by: {label_en: asc}) {
      code
      label_en
      label_de
    }
  }
`;

function DisplayFuels() {
  const { loading, error, data } = useQuery(GET_FUELS);

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error :(</p>;

  return data.fuel.map(({ id, category, label_en, label_de, fossil }) => (
    <div key={id}>
      <h3>EN: {label_en}, DE: {label_de} of category: {category}</h3>
      <p>{fossil ? "Fossil": "Bio"}</p>
    </div>
  ));
}

function DisplayRegions() {
  const { loading, error, data } = useQuery(GET_REGIONS);

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error :(</p>;

  return data.region.map(({ code, label_en, label_de }) => (
    <div key={code}>
      <h3>EN: {label_en}, DE: {label_de} </h3>
    </div>
  ));
}

export default function App() {
  return (
    <div>
      <h2>My first Apollo app 🚀</h2>
      <br />
      <DisplayFuels />
      <br />
      <DisplayRegions />
    </div>
  );
}