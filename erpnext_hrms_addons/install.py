import click

from erpnext_hrms_addons.setup import after_install as setup


def after_install():
    try:
        print("Setting up Hypebeast ERPNext-HRMS...")
        setup()

        click.secho("Thank you for installing Hypebeast ERPNext-HRMS!", fg="green")

    except Exception as e:
        click.secho(
            "Installation for Hypebeast ERPNext-HRMS app failed due to an error.",
            fg="bright_red"
        )
        raise e
