import React, { Component } from "react";
import PropTypes from "prop-types";
import "whatwg-fetch";
import _ from "lodash";
import {
  Banner,
  Button,
  CalloutCard,
  Card,
  FormLayout,
  Layout,
  Select,
  Stack,
  TextField,
} from "@shopify/polaris";
import Logo from "./logo";

const checkStatus = (response) => {
  if (response.status >= 200 && response.status < 300) {
    return response;
  }

  const error = new Error(response.statusText);
  error.response = response;
  throw error;
};

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      ...props.digest,
      banner: "hide",
    };
  }

  formNotChanged() {
    return _.isEqual(
      this.props.digest,
      _.omit(this.state, ["banner"]),
    );
  }

  updateDigest = () => {
    const options = {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      credentials: "same-origin",
      body: JSON.stringify(this.state),
    };

    fetch("/user/digest", options)
      .then(checkStatus)
      .then(response => response.json())
      .then((data) => {
        this.setState({
          banner: data.status === "succeed" ? "success" : "critical",
        });
      })
      .catch((data) => {
        this.setState({
          banner: data.status === "succeed" ? "success" : "critical",
        });
      });
  }

  showBanner() {
    if (this.state.banner === "hide") return null;

    return (
      <Banner
        onDismiss={() => this.setState({ banner: "hide" })}
        status={this.state.banner}
      >
        {
          this.state.banner === "success"
            ? "Successfully update settings"
            : "Something went wrong. Please contact ifyouseewendy@gmail.com"
        }
      </Banner>
    );
  }

  renderIndex() {
    return (
      <Layout>
        <Layout.Section>
          <Logo />
        </Layout.Section>
        <Layout.Section>
          <div className="main">
            <CalloutCard
              title={<p className="description">Get a digest email of your Github stars every week.</p>}
              illustration="https://assets-cdn.github.com/images/modules/logos_page/Octocat.png"
              primaryAction={{
                content: "Login via Github",
                url: "/auth/github",
              }}
            />
          </div>
        </Layout.Section>
      </Layout>
    );
  }

  renderDashboard() {
    console.log(this.state);
    return (
      <Layout>
        <Layout.Section>
          <Logo />
        </Layout.Section>
        {this.showBanner()}
        <Layout.Section>
          <div className="main">
            <Card sectioned>
              <FormLayout>
                <TextField
                  label="Email"
                  name="email"
                  type="email"
                  value={this.props.email}
                  disabled
                />
                <TextField
                  label="Github username"
                  name="github-username"
                  type="text"
                  value={this.props.githubUserName}
                  disabled
                />
                <Stack
                  alignment="trailing"
                  distribution="fill"
                >
                  <TextField
                    label="Send email"
                    prefix="at"
                    type="number"
                    min="1"
                    max="12"
                    value={this.state.hour}
                    onChange={v => this.setState({ hour: Number(v) })}
                    connectedRight={
                      <Select
                        label="meridiem"
                        labelHidden
                        options={["am", "pm"]}
                        value={this.state.meridiem}
                        onChange={meridiem => this.setState({ meridiem })}
                      />
                    }
                  />
                  <Select
                    options={["every week", "every day"]}
                    value={this.state.frequency}
                    onChange={frequency => this.setState({ frequency })}
                  />
                </Stack>
                <TextField
                  label="Digest count of each email"
                  type="number"
                  value={this.state.count}
                  min="0"
                  onChange={count => this.setState({ count: Number(count) })}
                />
                <Button primary disabled={this.formNotChanged()} onClick={this.updateDigest}>
                  Save
                </Button>
              </FormLayout>
            </Card>
          </div>
        </Layout.Section>
      </Layout>
    );
  }

  render() {
    if (this.props.email) {
      return this.renderDashboard();
    }
    return this.renderIndex();
  }
}

App.propTypes = {
  email: PropTypes.string.isRequired,
  githubUserName: PropTypes.string.isRequired,
  digest: PropTypes.shape({
    frequency: PropTypes.oneOf(["every week", "every day"]),
    hour: PropTypes.oneOf(_.range(1, 13)),
    meridiem: PropTypes.oneOf(["am", "pm"]),
    count: PropTypes.number.isRequired,
  }).isRequired,
};

export default App;
